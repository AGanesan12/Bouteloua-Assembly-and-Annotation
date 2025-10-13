library(dplyr)

## doing this on blfs1
## /data4/users/gam283/anchor

curt=read.table('Curtipendula-Othomaeum-156', header=T)
eri=read.table('Eriopoda-Othomaeum-60', header=T)
gra=read.table('Gracilis-Othomaeum-120', header=T)
curt$species='curtipendula'
eri$species='eripoda'
gra$species='gracilis'
d=rbind(curt, rbind(gra, eri))
d=d[d$gene!='interanchor',]

d %>% group_by(gene, species)%>% summarize(n=n()) %>% ungroup() %>% group_by(species,n)%>% summarize(copynumber=n())%>%arrange(-copynumber)

d=d%>%group_by(gene, species)%>% mutate(anchorcn=n())%>%ungroup()
b <- d %>%
  group_by(gene) %>%
  filter(
    any(species == "curtipendula" & anchorcn == 2) &
    any(species == "gracilis"    & anchorcn == 3) &
    any(species == "eripoda"     & anchorcn == 6)
  )

speciesfastas=c('curtipendula'='/data4/users/gam283/Bouteloua_curtipendula/Bcurtipendula.fasta',
                'gracilis'='/data4/users/gam283/Bouteloua_gracilis/Bgracilis.fasta',
                'eripoda'='/data4/users/gam283/Bouteloua_eriopoda/Beriopoda.fasta')
        
     
## start with 100 genes in gene tree??
#foreach(gene=faf$quickgene)  %dopar% { #[faf$n==100]){
set.seed(1000)
for(gene in sample(unique(b$gene), size=100, replace=F)){ #[faf$n==100]){
for(sp in unique(b$species)){

bed=b[b$gene==gene & b$species==sp,c('queryChr', 'queryStart', 'queryEnd', 'gene', 'strand', 'species')]
if(nrow(bed)!=0){
bed[,4]=paste0(bed$species, '_', bed$gene,'_', bed$queryChr, '_', bed$queryStart, '-', bed$queryEnd)
bed$species=NULL
}

outfile=paste0('~/transfer/bouteloua_gene_tree_beds/', gene, '_', sp, '.bed')

write.table(bed, outfile, row.names=F, col.names=F, sep='\t', quote=F)
system(paste0('bedtools getfasta -s -nameOnly -fi ', speciesfastas[sp], ' -bed ', outfile, ' >> ~/transfer/bouteloua_gene_tree_unalignedfa/', gene, '.fa'))
#### bedtools getfasta -s -fi test.fa -bed test.bed
}
 ## also do outgroup genomic region!
 sp='thomaeum'
 bed=b[b$gene==gene,c('refChr', 'referenceStart', 'referenceEnd', 'gene', 'strand', 'species')]
if(nrow(bed)!=0){
 bed$referenceStart=min(bed$referenceStart)
 bed$referenceEnd=max(bed$referenceEnd)
bed[,4]=paste0('thomaeum', '_', bed$gene,'_', bed$refChr, '_', bed$referenceStart, '-', bed$referenceEnd)
bed$species=NULL
 bed=bed[1,]
}
outfile=paste0('~/transfer/bouteloua_gene_tree_beds/', gene, '_', sp, '.bed')
write.table(bed, outfile, row.names=F, col.names=F, sep='\t', quote=F)
## couldn't write to alagu's directory, so do in transfer...
system(paste0('bedtools getfasta -s -nameOnly -fi ~/transfer/Othomaeum_renamed.faa -bed ', outfile, ' >> ~/transfer/bouteloua_gene_tree_unalignedfa/', gene, '.fa'))

 print(paste0(gene, ' the ', which(sample(unique(b$gene), size=100, replace=F)==gene), ' gene'))
}
