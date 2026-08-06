#!/usr/bin/env Rscript
# Tissue-expression heatmap for maize orthologs of orthogroups lost in Bouteloua (Figure 3)
# Input CSV columns expected: Gene, Category, then one numeric column per tissue/condition
# (values are qTeller expression values; log2(CPM+1) is computed here)
# Usage: Rscript plot_maize_expression_heatmap.R <bouteloua_heatmap_dataset.csv> <output.pdf>
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ComplexHeatmap)
  library(circlize)
  library(grid)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: Rscript plot_maize_expression_heatmap.R <bouteloua_heatmap_dataset.csv> <output.pdf>", call. = FALSE)
}
infile  <- args[1]
outfile <- args[2]

df <- read_csv(infile, show_col_types = FALSE)

# Combine duplicated genes and merge category labels
df_clean <- df %>%
  group_by(Gene) %>%
  summarise(
    Category = paste(unique(Category), collapse = "; "),
    across(where(is.numeric), ~ max(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  filter(rowSums(select(., where(is.numeric))) > 0)

# Order categories (edit to match the categories in your dataset)
df_clean$Category <- factor(
  df_clean$Category,
  levels = c("pectin", "pectin; aspartyl esterase", "cis-zeatin", "cis-zeatin; UDP-GT", "UDP-GT")
)
df_clean <- df_clean %>% arrange(Category, Gene)

# Expression matrix, log2(CPM+1)
mat <- df_clean %>% select(where(is.numeric)) %>% as.matrix()
mat <- log2(mat + 1)

short_gene <- sub("Zm00001eb", "Zm", df_clean$Gene)
rownames(mat) <- paste(short_gene, df_clean$Category, sep = " | ")

# Column (tissue/condition) labels - edit to match the columns in your dataset
colnames(mat) <- c(
  "Pollen", "Anther", "Sperm", "Bicellular\nmale gametophyte", "Microspore",
  "Seed\n22 DAP", "Embryo\n16 DAP", "Leaf", "Internode", "Root\ncortex",
  "Primary\nroot", "Waterlogging", "Drought", "Salt"
)

expr_colors <- colorRamp2(
  c(0, quantile(mat, 0.50), max(mat)),
  c("#0dd2e8", "#fceba5", "#ca1875")
)

ht <- Heatmap(
  mat,
  name = "log2(CPM+1)",
  col = expr_colors,
  cluster_rows = FALSE,
  cluster_columns = FALSE,
  row_split = df_clean$Category,
  row_title = NULL,
  row_gap = unit(2, "mm"),
  rect_gp = gpar(col = "white", lwd = 1),
  row_names_side = "left",
  row_names_gp = gpar(fontsize = 8),
  column_names_gp = gpar(fontsize = 10),
  column_names_rot = 45,
  heatmap_legend_param = list(title = "log2(CPM+1)")
)

pdf(outfile, width = 9, height = 7)
draw(ht)
dev.off()

message("Saved heatmap -> ", outfile)