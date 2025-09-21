#!/bin/bash
# Hifiasm v0.25.0-r726 (HiFi; n-haps=2 by default)
# Usage: ./01_hifiasm_assemble.sh <species> <reads.fastq> [threads=64] [hifiasm_bin=./hifiasm]
sp="$1"; fq="$2"; thr="${3:-64}"; HIFIASM_BIN="${4:-./hifiasm}"
mkdir -p "$sp"
"$HIFIASM_BIN" -o "${sp}/${sp}.asm" -t"$thr" "$fq" > "${sp}/${sp}.asm.log" 2>&1
echo "Done. Primary GFA: ${sp}/${sp}.asm.bp.p_ctg.gfa"
