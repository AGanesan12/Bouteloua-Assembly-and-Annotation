#!/bin/bash
# Helixer v0.3.5 (Apptainer/Singularity) using land_plant model
# Usage: ./10_helixer_predict.sh <species> <genome.fasta> [out.gff3] [gpu_id=1] [sif=helixer-docker_helixer_v0.3.5_cuda_12.2.2-cudnn8.sif]
sp="$1"; fasta="$2"; outgff="${3:-${sp}_helixer.gff3}"; gpu="${4:-1}"; SIF="${5:-helixer-docker_helixer_v0.3.5_cuda_12.2.2-cudnn8.sif}"
CUDA_VISIBLE_DEVICES="$gpu" apptainer run --nv "$SIF" Helixer.py \
  --fasta-path "$fasta" --lineage land_plant --gff-output-path "$outgff"
echo "Wrote $outgff"