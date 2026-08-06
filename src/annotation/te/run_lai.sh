#!/bin/bash
# LTR Assembly Index (LAI) - repeat-annotation quality metric (LTR_retriever v2.7)
# Usage: ./run_lai.sh <genome.fasta> <intact.gff3> <panEDTA.out> [threads=128]
fa="$1"; intact="$2"; out="$3"; thr="${4:-128}"
/programs/LTR_retriever-2.7/LAI -genome "$fa" -intact "$intact" -all "$out" -t "$thr"