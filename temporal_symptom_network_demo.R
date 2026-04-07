# =============================================================================
# Temporal Symptom Network Analysis — Independent Methods Practice
# Author: Dilay Sevahil
# Date: April 2026
# =============================================================================
#
# Description:
# Exploratory implementation of temporal symptom network methods using
# simulated EMA-style data generated via mlVARsim(). This script includes
# multilevel VAR network estimation, visualisation, centrality analysis,
# and stability testing.
#
# Purpose:
# Independent skill development toward within-person symptom dynamics research.
# Motivated by limitations of between-person causal models encountered in MSc 
# thesis work, and interest in the NSMD consortium's approach to personalised 
# symptom networks in psychotherapy.
#
# Note on data:
# Data are simulated using mlVARsim() from the mlVAR package. 
# mlVARsim generates data with a known true network structure, allowing 
# comparison of estimated vs true networks — a standard validation approach.
#
# Reference:
# Epskamp, S., Deserno, M. K., & Bringmann, L. F. (2022). mlVAR: 
# Multi-Level Vector Autoregression. R package version 0.6.1.
# https://CRAN.R-project.org/package=mlVAR
# =============================================================================

# 1. Load packages -------------------------------------------------------
library(mlVAR)
library(qgraph)
library(bootnet)
library(graphicalVAR)

# 2. Simulate EMA-style data ---------------------------------------------
set.seed(123)

nSymptoms <- 5
symptom_labels <- c("Sad", "Anx", "Fatigue", "Anhedonia", "Rumination")

sim_model <- mlVARsim(
  nPerson = 50,
  nNode   = nSymptoms,
  nTime   = 60,
  lag     = 1
)

sim_data <- sim_model$Data

# Use the metadata provided by mlVARsim (this is the correct ID column)
id_col <- sim_model$idvar

# Rename only the symptom columns to meaningful labels
colnames(sim_data)[colnames(sim_data) %in% sim_model$vars] <- symptom_labels

cat("Simulated EMA dataset prepared\n")
cat("Participants: ", length(unique(sim_data[[id_col]])), "\n")
cat("Time points per person: 60\n")
cat("Symptom variables: ", paste(symptom_labels, collapse = ", "), "\n\n")

# 3. Estimate multilevel VAR network -------------------------------------
cat("KEY CONCEPTUAL DISTINCTION FROM BETWEEN-PERSON MODELS:\n")
cat("Between-person: Do people with MORE symptom A have MORE symptom B?\n")
cat("Within-person temporal: When A increases FOR A PERSON, does B\n")
cat("increase for THAT SAME PERSON at the NEXT measurement?\n\n")
cat("The latter is what EMA captures and what mlVAR models.\n\n")

fit <- mlVAR(
  sim_data,
  vars      = symptom_labels,
  idvar     = id_col,
  lags      = 1,
  temporal  = "correlated",
  contemporaneous = "correlated",
  nCores    = 1,
  verbose   = FALSE
)

# 4. Compare true vs estimated temporal network -------------------------
layout(t(1:2))

plot(sim_model, "temporal",
     title = "True Temporal Network",
     layout = "circle",
     labels = symptom_labels,
     vsize = 10,
     mar = c(6, 6, 6, 6))

plot(fit, "temporal",
     title = "Estimated Temporal Network",
     layout = "circle",
     labels = symptom_labels,
     vsize = 10,
     mar = c(6, 6, 6, 6))

# 5. All three network structures ----------------------------------------
layout(matrix(1:3, 1, 3))

plot(fit, "temporal",
     title = "Temporal\n(lagged, directed)",
     layout = "circle",
     labels = symptom_labels,
     vsize = 10,
     mar = c(6, 6, 6, 6))

plot(fit, "contemporaneous",
     title = "Contemporaneous\n(same occasion)",
     layout = "circle",
     labels = symptom_labels,
     vsize = 10,
     mar = c(6, 6, 6, 6))

plot(fit, "between",
     title = "Between-subjects\n(stable differences)",
     layout = "circle",
     labels = symptom_labels,
     vsize = 10,
     mar = c(6, 6, 6, 6))

layout(1)

# 6. Centrality analysis -------------------------------------------------
temporal_net <- getNet(fit, "temporal", nonsig = "hide")

centralityPlot(temporal_net,
               include = c("InStrength", "OutStrength"),
               orderBy = "OutStrength",
               labels = symptom_labels)

cent <- centrality(temporal_net)
cat("\nOut-strength (symptom as predictor of others):\n")
print(sort(cent$OutDegree, decreasing = TRUE))
cat("\nIn-strength (symptom predicted by others):\n")
print(sort(cent$InDegree, decreasing = TRUE))

# 7. Single-subject (idiographic) network --------------------------------
# This is the exact logic that PECAN formalises through co-creation
single_person <- sim_data[sim_data[[id_col]] == 1, symptom_labels]

gvar_fit <- graphicalVAR(
  single_person,
  nLambda = 50,
  gamma   = 0.5
)

layout(t(1:2))
plot(gvar_fit, "temporal",
     labels = symptom_labels,
     title = "Single-Subject Temporal",
     vsize = 10)
plot(gvar_fit, "contemporaneous",
     labels = symptom_labels,
     title = "Single-Subject Contemporaneous",
     vsize = 10)
layout(1)

# 8. Save clean network plots for GitHub ------------------------------------
# (Run this once — it will create the plots folder and save high-quality images)

dir.create("plots", showWarnings = FALSE)   # creates the folder if it doesn't exist

# Temporal network (the main one everyone wants to see)
png("plots/05_temporal_network.png", width = 900, height = 900, res = 120)
qgraph(getNet(fit, "temporal"), 
       layout = "spring", 
       labels = symptom_labels, 
       title = "Temporal Network (Lag-1)",
       vsize = 8, 
       edge.labels = TRUE)
dev.off()

# Contemporaneous network
png("plots/06_contemporaneous_network.png", width = 900, height = 900, res = 120)
qgraph(getNet(fit, "contemporaneous"), 
       layout = "spring", 
       labels = symptom_labels, 
       title = "Contemporaneous Network",
       vsize = 8, 
       edge.labels = TRUE)
dev.off()

# Single-subject (idiographic) network — PECAN style
png("plots/07_single_subject_network.png", width=800, height=800)
qgraph(gvar_fit$PDC, layout="spring", labels=symptom_labels,
       title="Single-Subject (Idiographic) Network", vsize=8)
dev.off()

# 9. Clinical interpretation and PECAN relevance -------------------------
cat("\n=== CLINICAL INTERPRETATION ===\n\n")
cat("High out-strength symptoms = potential treatment entry points.\n")
cat("Targeting a high out-strength node first may produce cascading improvement.\n\n")
cat("RELEVANCE FOR PECAN:\n")
cat("Data-driven networks can be compared with networks co-created with patients and therapists.\n")
cat("This is exactly the kind of work the NSMD Patient Mapping Study investigates.\n\n")

cat("=== COMPLETE ===\n")
cat("Author: Dilay Sevahil | dilay.sevahil@gmail.com\n")

# Session info for reproducibility
writeLines(capture.output(sessionInfo()), "session_info.txt")
cat("session_info.txt saved\n")