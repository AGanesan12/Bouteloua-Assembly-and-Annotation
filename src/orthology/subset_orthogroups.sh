#!/bin/bash
# Subset Orthogroups.tsv (full gene lists per orthogroup) to a set of orthogroup IDs
# Usage: ./subset_orthogroups.sh <orthogroup_ids.txt> <Orthogroups.tsv> <output.tsv>
# orthogroup_ids.txt: one orthogroup ID per line (e.g. the first column of find_lost_orthogroups.sh output, minus header)
ids="$1"; tsv="$2"; out="$3"
awk 'NR==FNR{ids[$1]; next} FNR==1 || ($1 in ids)' "$ids" "$tsv" > "$out"
echo "Wrote $out"
