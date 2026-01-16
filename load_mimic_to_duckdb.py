import duckdb
from pathlib import Path

# Paths
DB_PATH = Path("data/mimic_to_omop.duckdb")
CSV_DIR = Path("data/mimic/")

# Connect to DuckDB (creates file if it doesn't exist)
con = duckdb.connect(DB_PATH)

# Loop over all CSV.gz files
for csv_file in CSV_DIR.glob("**/*.csv.gz"):
    print(csv_file)
    # Remove all extensions
    table_name = csv_file.name.replace('.csv.gz', '').replace('.', '_').replace('-', '_')
    print(f"Loading {csv_file} into table {table_name}...")
    # we set some fields to varchar to avoid ingestion issues, particularly from emar_detail
    # later ETL will fix this
    con.execute(f"CREATE SCHEMA IF NOT EXISTS mimic;")
    try:
        con.execute(f"""
            CREATE TABLE IF NOT EXISTS mimic.{table_name} AS
            SELECT * FROM read_csv_auto('{csv_file}');
        """)
    except duckdb.ConversionException:
        con.execute(f"""
            CREATE TABLE IF NOT EXISTS mimic.{table_name} AS
            SELECT * FROM read_csv_auto('{csv_file}', all_varchar=True);
        """)

con.close()
print(f"DuckDB database created at {DB_PATH} with all tables loaded.")