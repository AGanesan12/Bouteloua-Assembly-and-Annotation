#!/usr/bin/env Rscript
# Whole-genome synteny dot plot between a Bouteloua assembly and the Oropetium thomaeum
# outgroup, from AnchorWave anchor output (Figure S1)
# Usage: Rscript plot_synteny_dotplots.R <anchor_file> <min_block> <title> <output.png>
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(cowplot)
})
theme_set(theme_cowplot())

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 4) {
  stop("Usage: Rscript plot_synteny_dotplots.R <anchor_file> <min_block> <title> <output.png>", call. = FALSE)
}
filepath  <- args[1]
min_block <- as.numeric(args[2])
title     <- args[3]
outfile   <- args[4]

muted_colors <- c(
  "#b34064", "#459abf", "#68b488", "#b3ac40", "#8d4cba",
  "#bf9140", "#ae459a", "#99aabf", "#409f90", "#405973"
)
names(muted_colors) <- c(paste0("Chr0", 1:9), "Chr10")

process_anchors_to_dotplot <- function(filepath, color_palette = muted_colors, minBlock = 10,
                                        title = "", refChrs = c(paste0("Chr0", 1:9), "Chr10"),
                                        queryChrs = "") {
  data <- read.table(filepath, header = TRUE)
  data <- data[data$gene != "interanchor", ]

  if (queryChrs[1] == "") {
    queryChrs <- unique(data$queryChr[data$refChr %in% refChrs])
  }

  data <- data %>%
    group_by(blockIndex) %>%
    mutate(blockLength = dplyr::n()) %>%
    group_by(queryChr) %>%
    mutate(
      freqStrand = names(which.max(table(strand))),
      maxChr = max(queryStart),
      freqRef = names(which.max(table(refChr)))
    )

  data <- data[data$blockLength > minBlock, ]
  data$refChr <- factor(data$refChr, levels = c(paste0("Chr0", 1:9), "Chr10"))

  data <- data %>% arrange(freqRef, referenceStart, queryStart)
  data$queryChr <- factor(data$queryChr, levels = rev(data$queryChr[!duplicated(data$queryChr)]))
  data$revQueryStart <- data$queryStart
  data$revQueryStart[data$freqStrand == "-"] <- abs(data$queryStart - data$maxChr)[data$freqStrand == "-"]

  ggplot(
    data[data$refChr %in% names(color_palette) & data$refChr %in% refChrs & data$queryChr %in% queryChrs, ],
    aes(x = referenceStart / 1e6, y = revQueryStart / 1e6, color = refChr)
  ) +
    geom_point() +
    facet_grid(queryChr ~ refChr, scales = "free", space = "free") +
    scale_color_manual(values = color_palette) +
    theme(legend.position = "none") +
    theme(
      axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 9),
      strip.placement.y = "outside",
      strip.text = element_text(size = 8, color = "darkblue", face = "bold"),
      strip.text.y = element_text(angle = 0),
      strip.background = element_rect(fill = "lightblue", color = "darkblue", linewidth = 1),
      axis.text.y = element_text(size = 5),
      panel.spacing = unit(0.1, "lines")
    ) +
    geom_hline(aes(yintercept = maxChr / 1e6), lty = "dashed", color = "gray") +
    ggtitle(title)
}

p <- process_anchors_to_dotplot(
  filepath  = filepath,
  minBlock  = min_block,
  title     = title,
  refChrs   = paste0("gi_", 1:10)
)

ggsave(outfile, p, width = 10, height = 8, dpi = 300)
message("Saved synteny dot plot -> ", outfile)