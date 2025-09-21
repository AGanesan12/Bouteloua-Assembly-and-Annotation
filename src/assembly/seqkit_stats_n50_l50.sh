#!/bin/bash
# Seqkit v0.15.0 stats + custom N50/L50
# Usage: ./03_seqkit_stats_n50_l50.sh <assembly1.fasta> [assembly2.fasta ...]
SEQKIT="/programs/seqkit-0.15.0/seqkit"

for fa in "$@"; do
  echo "=== $fa ==="
  "$SEQKIT" stats "$fa"

  # N50
  "$SEQKIT" fx2tab -l -n "$fa" | awk '{print $2}' | sort -nr \
  | awk 'BEGIN{total=0}{lens[NR]=$1; total+=$1} END{half=total/2; s=0; for(i=1;i<=NR;i++){s+=lens[i]; if(s>=half){print "N50:",lens[i]; break}}}'

  # L50
  total=$("$SEQKIT" fx2tab -l "$fa" | awk '{s+=$NF} END{print s}')
  "$SEQKIT" fx2tab -l "$fa" | awk '{print $NF}' | sort -nr \
  | awk -v tot="$total" 'BEGIN{half=tot/2}{cum+=$1;n++; if(cum>=half){print "L50:",n; exit}}'
done