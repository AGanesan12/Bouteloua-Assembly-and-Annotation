#### Generate a species tree for three Bouteloua genomes

1. Run steps in `extract_regions_for_gene_trees.R` to get fastas of each anchor region (anchorwave already run to identify conserved anchors)
- here I used copies present in 2 in B. curtipendula, 3 in gracilis, and 6 in eripoda
2. Run `build_trees.sh` to align sequences with mafft and estimate gene trees with raxml-ng
3. Reformat tip labels for astral and grampa in `generate_grampa_and_astral_labelled_gene_trees.R`
4. Run `run_astral_then_grampa.sh` to generate a singly labelled species tree, then identify and place polyploidies on it