#### Genome assembly and QC workflow for the three Bouteloua species (PacBio HiFi reads)

1. Run `hifiasm_assemble.sh <species> <reads.fastq> [threads=64] [hifiasm_bin=./hifiasm]` to assemble HiFi reads with hifiasm (v0.25.0-r726, default n-haps=2), producing a primary contig GFA at `<species>/<species>.asm.bp.p_ctg.gfa`.
2. Run `extract_primary_contigs.sh <species> [asm_dir=<species>]` to convert the primary contig GFA (S-lines) into a FASTA.
3. Run `seqkit_stats_n50_l50.sh <assembly1.fasta> [assembly2.fasta ...]` (seqkit v0.15.0) to get basic assembly stats plus N50 and L50 for each assembly.
4. Run `busco_genome.sh <assembly.fasta> [threads=64] [lineage=embryophyta_odb10]` to assess assembly completeness with BUSCO v5.5.0 in genome mode.
