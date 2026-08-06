#!/bin/bash
# Verify raw HiFi BAM integrity, convert to FASTQ, and adapter-filter reads
# (samtools 1.20; HiFiAdapterFilt v3.0.0)
# Usage: ./clean_reads.sh <species> <reads.bam> <reads.bam.md5> [threads=64] [hifiadapterfilt_sh=./HiFiAdapterFilt/hifiadapterfilt.sh]
sp="$1"; bam="$2"; md5="$3"; thr="${4:-64}"
HIFIADAPTERFILT="${5:-./HiFiAdapterFilt/hifiadapterfilt.sh}"

md5sum -c "$md5" || { echo "MD5 check failed for $bam"; exit 1; }

fq="${sp}.fastq"
samtools bam2fq -@ "$thr" "$bam" > "$fq"

mkdir -p cleaned
"$HIFIADAPTERFILT" -p "$sp" -t "$thr" -o cleaned

echo "Cleaned reads for $sp written to cleaned/"