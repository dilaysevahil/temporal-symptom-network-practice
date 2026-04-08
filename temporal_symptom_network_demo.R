# =============================================================================
# Temporal Symptom Network Analysis — Independent Methods Practice
# Author: Dilay Sevahil
# Date: April 2026
# =============================================================================

# Load packages
suppressPackageStartupMessages({
  library(mlVAR)
  library(qgraph)
  library(bootnet)
  library(graphicalVAR)
})

# Simulate EMA-style data
set.seed(123)

nSymptoms <- 5
symptom_labels <- c("Sad", "Anx", "Fatigue", "Anhedonia", "Rumination")

sim_model <- mlVARsim(nPerson = 50, nNode = nSymptoms, nTime = 60, lag = 1)
sim_data  <- sim_model$Data

id_col <- sim_model$idvar
colnames(sim_data)[colnames(sim_data) %in% sim_model$vars] <- symptom_labels

# Estimate multilevel VAR network
fit <- mlVAR(sim_data, 
             vars = symptom_labels, 
             idvar = id_col, 
             lags = 1,
             temporal = "correlated", 
             contemporaneous = "correlated",
             nCores = 1, 
             verbose = FALSE)

# Save plots
dir.create("plots", showWarnings = FALSE)

# 01 True vs Estimated Temporal
png("plots/01_true_vs_estimated_temporal.png", width = 1200, height = 600, res = 120)
layout(t(1:2))
plot(sim_model, "temporal", title = "True Temporal Network", layout = "circle",
     labels = symptom_labels, vsize = 10)
plot(fit, "temporal", title = "Estimated Temporal Network", layout = "circle",
     labels = symptom_labels, vsize = 10)
dev.off()

# 02 Three network structures
png("plots/02_three_network_structures.png", width = 1800, height = 600, res = 120)
layout(matrix(1:3, 1, 3))
plot(fit, "temporal",       title = "Temporal\n(lagged, directed)", layout = "circle", labels = symptom_labels, vsize = 10)
plot(fit, "contemporaneous", title = "Contemporaneous\n(same occasion)", layout = "circle", labels = symptom_labels, vsize = 10)
plot(fit, "between",        title = "Between-subjects\n(stable differences)", layout = "circle", labels = symptom_labels, vsize = 10)
dev.off()

# 03 Centrality plot
temporal_net <- getNet(fit, "temporal", nonsig = "hide")
png("plots/03_centrality_plot.png", width = 1000, height = 600, res = 120)
centralityPlot(temporal_net, include = c("InStrength", "OutStrength"),
               orderBy = "OutStrength", labels = symptom_labels)
dev.off()

# 04 Single-subject idiographic network
single_person <- sim_data[sim_data[[id_col]] == 1, symptom_labels]
gvar_fit <- graphicalVAR(single_person, nLambda = 50, gamma = 0.5)

png("plots/04_single_subject_networks.png", width = 1200, height = 600, res = 120)
layout(t(1:2))
plot(gvar_fit, "temporal", labels = symptom_labels, title = "Single-Subject Temporal", vsize = 10)
plot(gvar_fit, "contemporaneous", labels = symptom_labels, title = "Single-Subject Contemporaneous", vsize = 10)
dev.off()

# 05-07 Clean spring-layout versions
png("plots/05_temporal_network.png", width = 900, height = 900, res = 120)
qgraph(getNet(fit, "temporal"), layout = "spring", labels = symptom_labels,
       title = "Temporal Network", vsize = 8, edge.labels = TRUE)
dev.off()

png("plots/06_contemporaneous_network.png", width = 900, height = 900, res = 120)
qgraph(getNet(fit, "contemporaneous"), layout = "spring", labels = symptom_labels,
       title = "Contemporaneous Network", vsize = 8, edge.labels = TRUE)
dev.off()

png("plots/07_single_subject_network.png", width = 900, height = 900, res = 120)
qgraph(gvar_fit$adjMat, layout = "spring", labels = symptom_labels,
       title = "Single-Subject Idiographic Network", vsize = 8, edge.labels = TRUE)
dev.off()

# Session info
writeLines(capture.output(sessionInfo()), "session_info.txt")
