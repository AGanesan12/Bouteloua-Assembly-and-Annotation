library(ggtree)  ## /programs/R-4.2.1-r9/bin/R
library(ggplot2) ## cbsu
library(cowplot)
theme_set(theme_cowplot())
library(ape)
library(treeio)
library(phytools)
library(reshape2)
library(dplyr)
library(ggridges)
library(stringr)

filenames=list.files('bouteloua_gene_trees/', pattern='_*.raxml.support')

### astral

b=lapply(c(1:length(filenames)), function(i){ 

print(i)
awto=read.tree(paste0('bouteloua_gene_trees/',filenames[i]))
awt=as.phylo(awto)
awt$tip.label=gsub('_R_', '', awt$tip.label)
  ## add to make sure outgroup is there, and is monophyletic - otherwise skip this tree
  if(any(substr(as.phylo(awt)$tip.label,1,8) %in% c('thomaeum'))){
#    if(is.monophyletic(awt, as.phylo(awt)$tip.label[substr(as.phylo(awt)$tip.label,1,6) %in% c('pvagin')])){
  awt=root(awt, as.phylo(awt)$tip.label[substr(as.phylo(awt)$tip.label,1,8) %in% c('thomaeum')], resolve.root=T)

## now keep only six digit code
awt$tip.label=str_split_fixed(awt$tip.label, '_',3)[,1]

return(awt)
}
#}
                                              })
                                              
                                              
d=do.call("c",b)

write.tree(d, paste0('anchors_aster.', Sys.Date(), '.tre'))

## grampa

b=lapply(c(1:length(filenames)), function(i){ 

print(i)
awto=read.tree(paste0('bouteloua_gene_trees/',filenames[i]))
awt=as.phylo(awto)
awt$tip.label=gsub('_R_', '', awt$tip.label)
  ## add to make sure outgroup is there, and is monophyletic - otherwise skip this tree
  if(any(substr(as.phylo(awt)$tip.label,1,8) %in% c('thomaeum'))){
#    if(is.monophyletic(awt, as.phylo(awt)$tip.label[substr(as.phylo(awt)$tip.label,1,6) %in% c('pvagin')])){
  awt=root(awt, as.phylo(awt)$tip.label[substr(as.phylo(awt)$tip.label,1,8) %in% c('thomaeum')], resolve.root=T)



## grampa needs blank_species, so use gene name, _, species
awt$tip.label=str_split_fixed(awt$tip.label, '_',3)[,1]

awt$tip.label=paste0(paste0('gene'),1:length(awt$tip.label), '_', awt$tip.label) ## not sure, addign in 1:length(awt$tip.label), to see if unique first part is necesary??
awt$edge.length=NULL
awt$node.label=NULL      
return(awt)
}
})
                                              
                                              
d=do.call("c",b)

write.tree(d, paste0('anchors_forgrampa.', Sys.Date(), '.tre'))


