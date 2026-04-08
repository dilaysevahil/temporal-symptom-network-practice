# Temporal Symptom Network Analysis — Independent Methods Practice

**Author:** Dilay Sevahil  
**Date:** April 2026

### Overview
This repository contains an independent methods practice project implementing multilevel temporal symptom networks using the `mlVAR` package. It demonstrates estimation of temporal, contemporaneous, and between-subjects networks on simulated EMA-style data, along with centrality analysis and single-subject idiographic networks.

### What the script does
- Simulates realistic EMA data with a known true network structure (`mlVARsim`)
- Fits a multilevel VAR model (`mlVAR`)
- Visualises true vs estimated temporal network
- Extracts temporal, contemporaneous, and between-subjects networks
- Computes node centrality (in-strength and out-strength)
- Estimates a single-subject idiographic network using `graphicalVAR`

### Files
- `temporal_symptom_network_demo.R` — full reproducible script
- `plots/` — all generated network visualisations 
- `session_info.txt` — exact R session and package versions

### Clinical relevance
High out-strength symptoms in the temporal network represent potential treatment entry points.  
This work directly relates to the NSMD Patient Mapping Study by showing how data-driven temporal networks can be compared with networks co-created with patients and therapists (PECAN method).

### How to run
```r
source("temporal_symptom_network_demo.R")

Repository created as independent methodological training.
Contact: dilay.sevahil@gmail.com
