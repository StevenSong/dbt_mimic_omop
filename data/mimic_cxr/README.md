# MIMIC-CXR Data Directory

This directory contains metadata files for MIMIC-CXR chest X-ray data.

**Source:** https://physionet.org/content/mimic-cxr-jpg/2.1.0/

## Required Files

Download the following files from PhysioNet (requires credentialed access):

| File | Description | Size |
|------|-------------|------|
| `mimic-cxr-2.0.0-metadata.csv.gz` | DICOM metadata (ViewPosition, StudyDate, etc.) | ~50 MB |
| `mimic-cxr-2.0.0-chexpert.csv.gz` | CheXpert NLP-derived labels (14 categories) | ~10 MB |
| `mimic-cxr-2.0.0-split.csv.gz` | Train/validate/test splits with dicom_id mapping | ~15 MB |

## Data Acquisition

### Prerequisites

1. Complete **CITI Data or Specimens Only Research** training
2. Create/login to PhysioNet account
3. Request access to MIMIC-CXR-JPG: https://physionet.org/content/mimic-cxr-jpg/2.1.0/
4. Sign the Data Use Agreement
5. Link your Google Cloud account to PhysioNet (for GCS access)

### Download via Google Cloud Storage (Recommended)

```bash
# Install gcloud CLI if not already installed
# https://cloud.google.com/sdk/docs/install

# Authenticate with your linked Google account
gcloud auth login

# Set your billing project (required for requester-pays bucket)
gcloud config set project YOUR_PROJECT_ID

# Download metadata files only (~75 MB total, minimal cost)
gsutil -u YOUR_PROJECT_ID cp \
    gs://mimic-cxr-jpg-2.1.0.physionet.org/mimic-cxr-2.0.0-metadata.csv.gz \
    gs://mimic-cxr-jpg-2.1.0.physionet.org/mimic-cxr-2.0.0-chexpert.csv.gz \
    gs://mimic-cxr-jpg-2.1.0.physionet.org/mimic-cxr-2.0.0-split.csv.gz \
    ./
```

### Alternative: Download via wget

```bash
wget --user YOUR_PHYSIONET_USER --ask-password \
    https://physionet.org/files/mimic-cxr-jpg/2.1.0/mimic-cxr-2.0.0-metadata.csv.gz \
    https://physionet.org/files/mimic-cxr-jpg/2.1.0/mimic-cxr-2.0.0-chexpert.csv.gz \
    https://physionet.org/files/mimic-cxr-jpg/2.1.0/mimic-cxr-2.0.0-split.csv.gz
```

## Image Access

The actual JPEG images (~558 GB) are stored on Google Cloud Storage:

```
gs://mimic-cxr-jpg-2.1.0.physionet.org/files/p{XX}/p{SUBJECT_ID}/s{STUDY_ID}/{DICOM_ID}.jpg
```

The ETL pipeline stores GCS URIs in the `image_occurrence.wadors_uri` column for on-demand access.

## After Download

Run the data loading script:

```bash
uv run python load_mimic_cxr_to_duckdb.py
```

Then run the dbt models:

```bash
uv run dbt run --select tag:mimic_cxr
```
