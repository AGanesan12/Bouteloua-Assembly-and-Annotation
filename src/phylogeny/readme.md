#### Generate a species tree for three Bouteloua genomes, and visualize synteny and polyploidy

1. Run steps in `extract_regions_for_gene_trees.R` to get fastas of each anchor region (anchorwave already run to identify conserved anchors). Here we used copies present in 2 in B. curtipendula, 3 in gracilis, and 6 in eriopoda.
2. Run `build_trees.sh` to align sequences with mafft and estimate gene trees with raxml-ng.
3. Reformat tip labels for astral and grampa in `generate_grampa_and_astral_labelled_gene_trees.R`.
4. Run `run_astral_then_grampa.sh` to generate a singly labelled species tree, then identify and place polyploidies on it (Figure 1D).
5. Run `Rscript plot_synteny_dotplots.R <anchor_file> <min_block> <title> <output.png>` once per species (B. curtipendula, B. gracilis, B. eriopoda vs. O. thomaeum) to generate the whole-genome synteny dot plots (Figure S1). `min_block` filters out short spurious alignment blocks and should be tuned per species/anchor-file density.