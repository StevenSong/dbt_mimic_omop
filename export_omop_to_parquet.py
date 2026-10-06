"""
Export the built OMOP CDM tables from DuckDB to Parquet.

Writes one <table>.parquet file per gold table into the output directory
(data/omop_parquet/ by default), which is the input layout OMOP_MEDS expects.
The me_* metrics tables are skipped as they are not part of the CDM.

Usage:
    python export_omop_to_parquet.py                        # all CDM tables
    python export_omop_to_parquet.py person death           # only the named tables
    python export_omop_to_parquet.py --out-dir /some/path   # export elsewhere

Note: the output is derived from MIMIC-IV and falls under the PhysioNet
credentialed data use agreement - do not share or commit it.
"""

import argparse
import sys
from pathlib import Path

import duckdb

# Paths
DB_PATH = Path("data/mimic_to_omop.duckdb")
DEFAULT_OUT_DIR = Path("data/omop_parquet/")
SCHEMA = "omop_gold"


def main():
    parser = argparse.ArgumentParser(description="Export OMOP CDM tables to Parquet.")
    parser.add_argument("tables", nargs="*", help="tables to export (default: all)")
    parser.add_argument("--out-dir", type=Path, default=DEFAULT_OUT_DIR)
    args = parser.parse_args()

    con = duckdb.connect(DB_PATH, read_only=True)

    tables = [
        row[0]
        for row in con.execute(
            "SELECT table_name FROM duckdb_tables() "
            "WHERE schema_name = ? AND table_name NOT LIKE 'me\\_%' ESCAPE '\\' "
            "ORDER BY table_name",
            [SCHEMA],
        ).fetchall()
    ]
    if args.tables:
        missing = set(args.tables) - set(tables)
        if missing:
            sys.exit(f"Unknown table(s) in {SCHEMA}: {', '.join(sorted(missing))}")
        tables = [t for t in tables if t in args.tables]

    # downstream tools read ids as signed int64, so refuse to export unsigned ids
    unsigned = con.execute(
        "SELECT table_name || '.' || column_name FROM duckdb_columns() "
        "WHERE schema_name = ? AND data_type LIKE 'U%INT' AND list_contains(?, table_name)",
        [SCHEMA, tables],
    ).fetchall()
    if unsigned:
        sys.exit(f"Unsigned integer columns found, rebuild with dbt first: {unsigned}")

    args.out_dir.mkdir(parents=True, exist_ok=True)
    for table in tables:
        out_fp = args.out_dir / f"{table}.parquet"
        print(f"Exporting {SCHEMA}.{table} to {out_fp}...")
        con.execute(
            f"COPY {SCHEMA}.{table} TO '{out_fp}' (FORMAT parquet, COMPRESSION zstd)"
        )
        n_db = con.execute(f"SELECT count(*) FROM {SCHEMA}.{table}").fetchone()[0]
        n_pq = con.execute(f"SELECT count(*) FROM read_parquet('{out_fp}')").fetchone()[0]
        if n_db != n_pq:
            sys.exit(f"Row count mismatch for {table}: {n_db} in DuckDB, {n_pq} in parquet")
        print(f"  {n_pq} rows")

    con.close()
    print(f"Exported {len(tables)} tables to {args.out_dir}")


if __name__ == "__main__":
    main()
