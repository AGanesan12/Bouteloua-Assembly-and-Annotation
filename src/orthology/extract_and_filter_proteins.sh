#!/bin/bash
# Extract CDS/peptide FASTAs from Helixer GFF3s and filter to peptides >= min_aa (gffread v0.9.12)
# Usage: ./extract_and_filter_proteins.sh <gff_dir> <genome_dir> <out_dir> [min_aa=50] [genome_ext=fna]
gffdir="$1"; genomedir="$2"; outdir="$3"; minaa="${4:-50}"; ext="${5:-fna}"
GFFREAD=/programs/gffread-0.9.12/gffread/gffread
mkdir -p "$outdir" "$outdir/cleaned"

for gff in "$gffdir"/*.gff3; do
  base=$(basename "$gff" .gff3)
  genome="${genomedir}/${base}.${ext}"
  if [[ ! -f "$genome" ]]; then
    echo "ERROR: genome not found for $base ($genome)"; continue
  fi
  echo "Extracting proteins for $base"
  "$GFFREAD" "$gff" -g "$genome" \
    -y "${outdir}/${base}.faa" \
    -x "${outdir}/${base}.cds.fna" \
    2> "${outdir}/${base}.gffread.log"
done

for f in "$outdir"/*.faa; do
  awk -v MIN="$minaa" '
    /^>/ {
      if (seq && length(seq) >= MIN) { print header; print seq }
      header=$0; seq=""; next
    }
    { seq = seq $0 }
    END { if (seq && length(seq) >= MIN) { print header; print seq } }
  ' "$f" > "$outdir/cleaned/$(basename "$f")"
done

echo "Filtered peptide FASTAs (>= ${minaa} aa) written to ${outdir}/cleaned/"
