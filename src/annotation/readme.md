Gene prediction and annotation summary for the three Bouteloua genomes (TE annotation is located in `te/` subfolder, see `te/readme.md`)

1. Run `helixer_predict.sh <species> <genome.fasta> [out.gff3] [gpu_id=1] [sif]` to predict gene models with Helixer (v0.3.5, land_plant lineage), producing a GFF3 of predicted genes.
2. Run `gene_counts_and_cds_stats.sh <helixer.gff3>` to get a quick QC summary of the annotation: total gene count, total CDS count, total CDS length, and average CDS length.
3. Run `gffread_extract.sh <annotations.gff3> <genome.fasta> [out_prefix]` (gffread v0.9.12) to pull out CDS and peptide FASTAs (`<prefix>.CDS.fa`, `<prefix>.pep.fa`) from the annotation.
4. For transposable element annotation, see `te/readme.md`.
