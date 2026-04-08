# Temporal Symptom Network Analysis - Independent Methods Practice

**Author:** Dilay Sevahil  
**Date:** April 2026

### Overview
This repository contains my independent methods practice project implementing **multilevel temporal symptom networks** using the `mlVAR` package. It demonstrates estimation of temporal, contemporaneous, and between-subjects networks on simulated EMA-style data, along with centrality analysis and single-subject (idiographic) networks.

### What the script does
- Simulates realistic EMA data with a known true network structure (`mlVARsim`)
- Fits a multilevel VAR model (`mlVAR`) with correlated random effects
- Visualises and compares the **true** vs. **estimated** temporal network
- Extracts all three network types: temporal (lagged), contemporaneous, and between-subjects
- Computes node centrality (in-strength and out-strength)
- Estimates a single-subject idiographic network using `graphicalVAR` — the exact logic formalised in the **PECAN co-creation method**

### Key files
- `temporal_symptom_network_demo.R` — full reproducible script  
- `plots/` folder — all generated visualisations  
- `session_info.txt` — exact R session and package versions

### Plots included
- True vs. estimated temporal network  
- Temporal, contemporaneous, and between-subjects networks  
- Centrality plot (In-strength and Out-strength)  
- Single-subject idiographic network  

### Clinical & NSMD relevance
High out-strength symptoms in the temporal network represent promising treatment entry points, as intervening on them may produce cascading improvements across the symptom system.  

This work directly connects to the NSMD Patient Mapping Study by showing how data-driven temporal networks can be compared with networks co-created with patients and therapists (PECAN method). It builds on my recent preprint in causal longitudinal modelling:

→ [Investigating the Mediating Role of Family Support and Peer Acceptance… (Causal Mediation Analysis)](https://doi.org/10.31234/osf.io/nyahz_v1)

### How to run
```r
# Simply source the script
source("temporal_symptom_network_demo.R")
