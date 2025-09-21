#!/bin/bash
# BUSCO v5.5.0 (genome mode) with embryophyta_odb10
# Usage: ./04_busco_genome.sh <assembly.fasta> [threads=64] [lineage=embryophyta_odb10]
fa="$1"; thr="${2:-64}"; lineage="${3:-embryophyta_odb10}"
base=$(basename "$fa" .fasta)
busco -i "$fa" -o "busco_${base}" -l "$lineage" -m genome -c "$thr"