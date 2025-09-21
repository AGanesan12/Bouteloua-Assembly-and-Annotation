#!/bin/bash
# Count gene features and CDS stats from GFF3
# Usage: ./11_gene_counts_and_cds_stats.sh <helixer.gff3>
gff="$1"
echo -n "Genes: "; grep -P '\tgene\t' "$gff" | wc -l
awk '$3=="CDS"{len+=$5-$4+1; n++} END{print "Total_CDS:",n; print "Total_CDS_len:",len; if(n>0) printf("Avg_CDS_len: %.2f\n", len/n)}' "$gff"
