#!/bin/bash
# Identify orthogroups with zero genes in all Bouteloua species and >0 genes in every outgroup species
# Usage: ./find_lost_orthogroups.sh <Orthogroups.GeneCount.tsv> <bouteloua_species_csv> <outgroup_species_csv> <output.tsv>
# Species names must exactly match the column headers in Orthogroups.GeneCount.tsv
tsv="$1"; bout="$2"; outg="$3"; out="$4"

python3 - "$tsv" "$bout" "$outg" "$out" << 'PY'
import sys, csv
tsv, bout, outg, out = sys.argv[1:5]
bout = bout.split(",")
outg = outg.split(",")
with open(tsv) as f:
    reader = csv.reader(f, delimiter="\t")
    header = next(reader)
    bidx = [header.index(s) for s in bout]
    oidx = [header.index(s) for s in outg]
    with open(out, "w") as o:
        o.write("\t".join(header) + "\n")
        for row in reader:
            if all(int(row[i]) == 0 for i in bidx) and all(int(row[i]) > 0 for i in oidx):
                o.write("\t".join(row) + "\n")
PY
echo "Wrote $out"
