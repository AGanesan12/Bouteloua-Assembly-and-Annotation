## this is on xm01
# /workdir/mcs368/bouteloua

for i in ~/transfer/bouteloua_gene_tree_unalignedfa/*.fa
do
gene=$(basename "$i" .fa)

if [ ! -f bouteloua_aligned/${gene}.aln.fa ]
then

/programs/mafft-7.525-with-extensions/bin/mafft --thread 12 --genafpair --maxiterate 1000 --adjustdirection ~/transfer/bouteloua_gene_tree_unalignedfa/${gene}.fa > bouteloua_aligned/${gene}.aln.fa
sed -i 's/()//g' bouteloua_aligned/${gene}.aln.fa
sed -i 's/_R_//g' bouteloua_aligned/${gene}.aln.fa

## build tree
/programs/raxml-ng_v1.2.0/raxml-ng --model GTR+G --threads 16 --bs-trees 100  --seed 12345 \
  --msa bouteloua_aligned/${gene}.aln.fa --prefix bouteloua_gene_trees/${gene} --all


fi
done




