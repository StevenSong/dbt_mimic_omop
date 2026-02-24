"""
Load MIMIC-CXR metadata CSV files into DuckDB.

This script loads the following tables into the mimic_cxr schema:
- cxr_record_list: DICOM ID -> Study ID -> Subject ID mapping
- cxr_study_list: Study-level metadata  
- mimic_cxr_metadata: Extracted DICOM metadata fields
- mimic_cxr_chexpert: CheXpert NLP-derived labels (14 categories)

Prerequisites:
- Download metadata files from PhysioNet to data/mimic_cxr/
- See data/mimic_cxr/README.md for download instructions
"""

import duckdb
from pathlib import Path

# Paths
DB_PATH = Path("data/mimic_to_omop.duckdb")
CSV_DIR = Path("data/mimic_cxr/")

# Expected files and their table names
# Based on MIMIC-CXR-JPG v2.1.0: https://physionet.org/content/mimic-cxr-jpg/2.1.0/
EXPECTED_FILES = {
    "mimic-cxr-2.0.0-metadata.csv.gz": "mimic_cxr_metadata",
    "mimic-cxr-2.0.0-chexpert.csv.gz": "mimic_cxr_chexpert",
    "mimic-cxr-2.0.0-split.csv.gz": "mimic_cxr_split",
}


def main():
    # Check if CSV directory exists
    if not CSV_DIR.exists():
        print(f"Error: Directory {CSV_DIR} does not exist.")
        print("Please create it and download the MIMIC-CXR metadata files.")
        print("See data/mimic_cxr/README.md for instructions.")
        return

    # Check for expected files
    found_files = list(CSV_DIR.glob("*.csv.gz"))
    if not found_files:
        print(f"No .csv.gz files found in {CSV_DIR}")
        print("Please download the MIMIC-CXR metadata files first.")
        print("See data/mimic_cxr/README.md for instructions.")
        return

    # Connect to DuckDB
    print(f"Connecting to DuckDB at {DB_PATH}...")
    con = duckdb.connect(str(DB_PATH))

    # Create schema
    con.execute("CREATE SCHEMA IF NOT EXISTS mimic_cxr;")
    print("Created schema: mimic_cxr")

    # Load each CSV file
    loaded_count = 0
    for csv_file in CSV_DIR.glob("*.csv.gz"):
        # Determine table name
        if csv_file.name in EXPECTED_FILES:
            table_name = EXPECTED_FILES[csv_file.name]
        else:
            # Fallback: sanitize filename
            table_name = csv_file.name.replace(".csv.gz", "").replace(".", "_").replace("-", "_")

        print(f"Loading {csv_file.name} into mimic_cxr.{table_name}...")

        try:
            # Drop existing table if it exists
            con.execute(f"DROP TABLE IF EXISTS mimic_cxr.{table_name};")

            # Load CSV with proper quote handling for fields containing commas
            con.execute(f"""
                CREATE TABLE mimic_cxr.{table_name} AS
                SELECT * FROM read_csv_auto(
                    '{csv_file}', 
                    header=true,
                    quote='"',
                    escape='"'
                );
            """)

            # Get row count
            result = con.execute(f"SELECT COUNT(*) FROM mimic_cxr.{table_name}").fetchone()
            row_count = result[0] if result else 0
            print(f"  -> Loaded {row_count:,} rows")
            loaded_count += 1

        except duckdb.Error as e:
            print(f"  -> Error loading {csv_file.name}: {e}")
            # Try with all_varchar as fallback
            try:
                con.execute(f"""
                    CREATE TABLE mimic_cxr.{table_name} AS
                    SELECT * FROM read_csv_auto('{csv_file}', header=true, all_varchar=true);
                """)
                result = con.execute(f"SELECT COUNT(*) FROM mimic_cxr.{table_name}").fetchone()
                row_count = result[0] if result else 0
                print(f"  -> Loaded {row_count:,} rows (as varchar)")
                loaded_count += 1
            except duckdb.Error as e2:
                print(f"  -> Failed to load even with all_varchar: {e2}")

    con.close()

    print(f"\nDone! Loaded {loaded_count} tables into mimic_cxr schema.")
    print(f"Database: {DB_PATH}")

    # Print expected files status
    print("\nExpected files status:")
    for filename, table_name in EXPECTED_FILES.items():
        filepath = CSV_DIR / filename
        status = "✓ Found" if filepath.exists() else "✗ Missing"
        print(f"  {status}: {filename} -> mimic_cxr.{table_name}")


if __name__ == "__main__":
    main()
