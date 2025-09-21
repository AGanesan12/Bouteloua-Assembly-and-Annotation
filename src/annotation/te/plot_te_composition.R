#!/usr/bin/env Rscript

# TE Composition Barplot Script
# Usage:
#   Rscript te_composition_figure2.R input.tsv output.pdf
#
# Input: tab-delimited file with columns:
#   species   class   bpMasked   pctMasked
# Example:
#   Bcurtipendula   Gypsy   45779939   7.01%

suppressPackageStartupMessages({
  library(tidyverse)
  library(scales)
})

# Args
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: Rscript te_composition_figure2.R input.tsv output.pdf", call. = FALSE)
}
infile  <- args[1]
outfile <- args[2]

# Data
df <- read.delim(infile, header = TRUE, sep = "\t") %>%
  mutate(
    pctMasked = readr::parse_number(pctMasked) / 100
  )

# Factor ordering
species_order <- unique(df$species)
class_order <- df %>%
  group_by(class) %>%
  summarise(total = sum(pctMasked), .groups = "drop") %>%
  arrange(desc(total)) %>%
  pull(class)

df <- df %>%
  mutate(
    species = factor(species, levels = species_order),
    class   = factor(class, levels = class_order)
  )

# Plot
p <- ggplot(df, aes(x = species, y = pctMasked, fill = class)) +
  geom_bar(stat = "identity", width = 0.75, color = "grey15", linewidth = 0.2) +
  scale_y_continuous(labels = percent_format(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "TE composition by superfamily",
    x = "Species",
    y = "% of genome masked",
    fill = "Superfamily"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0, size = 12, margin = margin(b = 6)),
    axis.title = element_text(size = 11),
    axis.text = element_text(color = "black"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "right",
    legend.key.height = unit(0.5, "cm"),
    legend.text = element_text(size = 9)
  )

# Save
ggsave(outfile, p, width = 7, height = 5)

message("Saved plot -> ", outfile)
