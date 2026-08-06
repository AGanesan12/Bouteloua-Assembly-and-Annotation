#!/bin/bash
# Run OrthoFinder (v3.1.3, DIAMOND all-vs-all search) across filtered proteomes
# Usage: ./run_orthofinder.sh <protein_dir> <run_name> [threads=48]
pdir="$1"; name="$2"; thr="${3:-48}"
orthofinder -f "$pdir" -t "$thr" -a "$thr" -S diamond -n "$name"
