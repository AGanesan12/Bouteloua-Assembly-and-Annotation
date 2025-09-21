#!/bin/bash
# gffread v0.9.12 → CDS & peptide FASTA
# Usage: ./12_gffread_extract.sh <annotations.gff3> <genome.fasta> [out_prefix (default: basename gff)]
GFFREAD=/programs/gffread-0.9.12/gffread/gffread
gff="$1"; gen="$2"; pre="${3:-$(basename "$gff" .gff3)}"
"$GFFREAD" "$gff" -g "$gen" -x "${pre}.CDS.fa" -y "${pre}.pep.fa"
echo "Wrote ${pre}.CDS.fa and ${pre}.pep.fa"