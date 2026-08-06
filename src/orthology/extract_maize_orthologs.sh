#!/bin/bash
# Extract maize gene IDs from a subsetted Orthogroups.tsv (e.g. output of subset_orthogroups.sh)
# for downstream GO enrichment (MaizeMine) and expression analysis (qTeller)
# Usage: ./extract_maize_orthologs.sh <subset_Orthogroups.tsv> <maize_column_name> <output.txt>
tsv="$1"; maizecol="$2"; out="$3"
awk -F'\t' -v col="$maizecol" '
NR==1 { for (i=1;i<=NF;i++) if ($i==col) c=i; next }
{ if (c && $c != "") print $c }
' "$tsv" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | sort -u > "$out"
echo "Wrote $out"
