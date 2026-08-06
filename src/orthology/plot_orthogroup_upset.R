#!/usr/bin/env Rscript
# Orthogroup sharing UpSet plots (Figure 2: collapsed Bouteloua-vs-outgroups view;
# Figure S2: full per-species view)
# Usage:
#   Rscript plot_orthogroup_upset.R <Orthogroups.GeneCount.tsv> <out_main.png> <out_supplement.png>
suppressPackageStartupMessages({
  library(tidyverse)
  library(UpSetR)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript plot_orthogroup_upset.R <Orthogroups.GeneCount.tsv> <out_main.png> <out_supplement.png>", call. = FALSE)
}
infile   <- args[1]
out_main <- args[2]
out_supp <- args[3]

# Species column names must match the header of Orthogroups.GeneCount.tsv
bout_cols <- c("Bcurtipendula", "Bgracilis", "Beriopoda")
outgroup_cols <- c(
  "Cdactylon", "Ecoracana", "Ecurvula", "Eindica", "Othomaeum",
  "Salterniflorus", "Zjaponica", "Zmacrostachya", "Zsinica", "maize"
)

df <- read_tsv(infile, show_col_types = FALSE)

# Convert gene counts to presence/absence
binary_df <- df
binary_df[, -1] <- (binary_df[, -1] > 0) * 1

# ---- Figure 2: collapsed main figure (outgroups combined into one set) ----
main_upset_df <- binary_df %>%
  mutate(
    All_outgroups = if_else(
      rowSums(select(., all_of(outgroup_cols))) == length(outgroup_cols), 1, 0
    )
  ) %>%
  select(all_of(bout_cols), All_outgroups) %>%
  as.data.frame()

png(out_main, width = 6000, height = 2800, res = 600)
upset(
  main_upset_df,
  sets = c("All_outgroups", "Beriopoda", "Bgracilis", "Bcurtipendula"),
  keep.order = TRUE,
  intersections = list(
    c("All_outgroups", "Beriopoda", "Bgracilis", "Bcurtipendula"),
    c("Beriopoda", "Bgracilis", "Bcurtipendula"),
    c("All_outgroups"),
    c("All_outgroups", "Bcurtipendula"),
    c("All_outgroups", "Bgracilis"),
    c("All_outgroups", "Beriopoda"),
    c("Bcurtipendula", "Bgracilis"),
    c("Bcurtipendula", "Beriopoda"),
    c("Bgracilis", "Beriopoda")
  ),
  order.by = "freq",
  decreasing = TRUE,
  queries = list(list(
    query = intersects, params = list("All_outgroups"),
    color = "#D55E00", active = TRUE, query.name = "105 lost orthogroups"
  )),
  mainbar.y.label = "Orthogroup intersections",
  sets.x.label = "Orthogroups per group",
  text.scale = c(2.0, 1.8, 1.8, 1.6, 2.0, 1.8)
)
dev.off()

# ---- Figure S2: full per-species supplement ----
supp_upset_df <- binary_df %>%
  select(all_of(c(outgroup_cols, bout_cols))) %>%
  as.data.frame()

png(out_supp, width = 6000, height = 2800, res = 600)
upset(
  supp_upset_df,
  sets = c(
    "maize", "Cdactylon", "Ecoracana", "Ecurvula", "Eindica", "Othomaeum",
    "Salterniflorus", "Zjaponica", "Zmacrostachya", "Zsinica",
    "Bcurtipendula", "Bgracilis", "Beriopoda"
  ),
  keep.order = TRUE,
  nintersects = 80,
  order.by = "freq",
  decreasing = TRUE,
  queries = list(list(
    query = intersects, params = as.list(outgroup_cols),
    color = "#D55E00", active = TRUE, query.name = "105 lost orthogroups"
  )),
  mainbar.y.label = "Orthogroup intersections",
  sets.x.label = "Orthogroups per species",
  text.scale = c(2.0, 1.8, 1.8, 1.6, 2.0, 1.8)
)
dev.off()

message("Saved main figure -> ", out_main)
message("Saved supplemental figure -> ", out_supp)