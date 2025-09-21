#!/bin/bash
# Extract primary contigs (S-lines) from hifiasm GFA to FASTA
# Usage: ./02_extract_primary_contigs.sh <species> [asm_dir=<species>]
sp="$1"; adir="${2:-$sp}"
gfa="${adir}/${sp}.asm.bp.p_ctg.gfa"
fa="${adir}/${sp}.asm.bp.p_ctg.fasta"
awk '/^S/{print ">"$2"\n"$3}' "$gfa" > "$fa"
echo "Wrote $fa"