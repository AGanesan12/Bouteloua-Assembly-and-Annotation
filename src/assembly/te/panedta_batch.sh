#!/bin/bash
# panEDTA across multiple genomes (uses local symlinks if paths are messy)
# Usage: ./22_panedta_batch.sh <genome_list.txt> [threads=128] [cds.fa (optional)]
list="$1"; thr="${2:-128}"; cds="${3:-}"
if [[ -n "$cds" ]]; then
  panEDTA/panEDTA.sh -g "$list" -c "$cds" -t "$thr"
else
  panEDTA/panEDTA.sh -g "$list" -t "$thr"
fi
