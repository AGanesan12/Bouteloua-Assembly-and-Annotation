#!/bin/bash
# Pull overall % genome masked from panEDTA *.tbl reports
# Usage: ./23_te_percent_masked.sh <species1.tbl> [species2.tbl ...]
for tbl in "$@"; do
  sp=$(basename "$tbl" .fasta.mod.panEDTA.tbl)
  awk -v SP="$sp" '
    /^bases masked:/ {
      if (match($0, /\(([[:space:]]*[0-9.]+[[:space:]]*%)[[:space:]]*\)/, m)) {
        gsub(/[[:space:]]/, "", m[1]); print SP "\t" m[1]
      }
    }' "$tbl"
done