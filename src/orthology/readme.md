#### Orthogroup inference across thirteen PACMAD proteomes, and identification of orthogroups lost in Bouteloua

Inputs: gene predictions for the three Bouteloua assemblies, eight chromosome-scale Chloridoideae genomes (Zoysia japonica, Z. sinica, Z. macrostachya, Eleusine indica, E. coracana, Sporobolus alterniflorus, Cynodon dactylon, Eragrostis curvula), Oropetium thomaeum, and Zea mays B73 NAM 5.0 (canonical annotation, not re-predicted).

1. Predict gene models for every non-maize proteome with `helixer_predict.sh` (see `../annotation/readme.md`), then run `extract_and_filter_proteins.sh <gff_dir> <genome_dir> <out_dir> [min_aa=50]` to pull CDS/peptide FASTAs with gffread and keep only peptides >= 50 aa. Maize uses the existing B73v5 (Zm00001eb.1) protein set directly.
2. Run `run_orthofinder.sh <protein_dir> <run_name> [threads=48]` (OrthoFinder v3.1.3, DIAMOND search) on the combined filtered peptide FASTAs from all thirteen proteomes.
3. Run `find_lost_orthogroups.sh <Orthogroups.GeneCount.tsv> <bouteloua_species_csv> <outgroup_species_csv> <output.tsv>` to identify orthogroups with zero genes in all three Bouteloua species and at least one gene in every outgroup species (105 orthogroups in the paper).
4. Run `subset_orthogroups.sh <orthogroup_ids.txt> <Orthogroups.tsv> <output.tsv>` to pull the full per-species gene lists for those orthogroups from OrthoFinder's `Orthogroups.tsv`.
5. Run `extract_maize_orthologs.sh <subset_Orthogroups.tsv> <maize_column_name> <output.txt>` to get the maize gene IDs for those orthogroups, used for GO enrichment (MaizeMine) and tissue expression analysis (qTeller).
