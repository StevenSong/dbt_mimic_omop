# Convert MIMIC-IV to OMOP Format with this Conversion Tool

## Requirements



## Step by Step Guide:

### 1. Download Vocabularies

Download the required vocabularies at 
https://athena.ohdsi.org/vocabulary/list

http://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/
```
wget -P data/mimic/annotations \
     -O data/mimic/annotations/discharge_annotations.csv.gz \
     https://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/discharge_annotations.csv.gz
```

```
wget -P data/mimic/annotations \
     -O data/mimic/annotations/radiology_annotations.csv.gz \
     https://cogstack-mimic-demo.sites.er.kcl.ac.uk/annotations/radiology_annotations.csv.gz
```

