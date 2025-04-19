library(tidyverse)
library(phyloseq)
library(DESeq2)


### Loading and prepping phyloseq object, edit file path if needed ###
load("phyloseq_file.RData")

phylo_plus1 <- transform_sample_counts(phyloseq_file, function(x) x+1)
# (untrans. phyloseq got zeros error for both climate and captivity predictors)


### Subsetting to mammalian orders of interest ###
tubulidentata_phylo <- subset_samples(phylo_plus1,
                                   Taxonomy_Order == "Tubulidentata")
pilosa_phylo <- subset_samples(phylo_plus1,
                               Taxonomy_Order == "Pilosa")
primate_phylo <- subset_samples(phylo_plus1,
                                Taxonomy_Order == "Primates")


### DESeq objects and analysis ###
# nonspecific codes will be commented out:
# climate_deseq <- phyloseq_to_deseq2(phylo_plus1, ~`Climate..basic.`)
# captivity_deseq <- phyloseq_to_deseq2(phylo_plus1, ~`captive_wild`)

tubu_clim <- phyloseq_to_deseq2(tubulidentata_phylo, ~`Climate..basic.`)
tubu_capt <- phyloseq_to_deseq2(tubulidentata_phylo, ~`captive_wild`)

pilo_clim <- phyloseq_to_deseq2(pilosa_phylo, ~`Climate..basic.`)
pilo_capt <- phyloseq_to_deseq2(pilosa_phylo, ~`captive_wild`)

prim_clim <- phyloseq_to_deseq2(primate_phylo, ~`Climate..basic.`)
prim_capt <- phyloseq_to_deseq2(primate_phylo, ~`captive_wild`)


## Warning: these two take an extra long time to run!
## (DESeqs for ENTIRE zoo dataset)
#DESEQ_clim <- DESeq(climate_deseq)
#DESEQ_capt <- DESeq(captivity_deseq)

deseq_tubu_clim <- DESeq(tubu_clim)
deseq_tubu_capt <- DESeq(tubu_capt)

deseq_pilo_clim <- DESeq(pilo_clim)
deseq_pilo_capt <- DESeq(pilo_capt)

deseq_prim_clim <- DESeq(prim_clim)
deseq_prim_capt <- DESeq(prim_capt)

# Results tables
# note to self: reference set as earliest in alphabetical order if undefined
# e.g., "captive" status will be reference for captive-wild predictor
res_tubu_clim <- results(deseq_tubu_clim, tidy = TRUE)
res_tubu_capt <- results(deseq_tubu_capt, tidy = TRUE)
# reference climate: B

res_pilo_clim <- results(deseq_pilo_clim, tidy = TRUE)
res_pilo_capt <- results(deseq_pilo_capt, tidy = TRUE)
# reference climate: A

res_prim_clim <- results(deseq_prim_clim, tidy = TRUE)
res_prim_capt <- results(deseq_prim_capt, tidy = TRUE)
# reference climate: A


### Volcano plots ###
# tubulidentata
vol_tubu_clim <- res_tubu_clim %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Tubulidentata (Climate)")
vol_tubu_capt <- res_tubu_capt %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Tubulidentata (Captive vs. Wild)")

# pilosa
vol_pilo_clim <- res_pilo_clim %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Pilosa (Climate)")
vol_pilo_capt <- res_pilo_capt %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Pilosa (Captive vs. Wild)")

# primate
vol_prim_clim <- res_prim_clim %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Climate)")
vol_prim_capt <- res_prim_capt %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Captive vs. Wild)")

### File Saves ###
ggsave(filename = "tubulidentata_climate_deseq.png",vol_tubu_clim)
ggsave(filename = "tubulidentata_captivity_deseq.png", vol_tubu_capt)

ggsave(filename = "pilosa_climate_deseq.png", vol_pilo_clim)
ggsave(filename = "pilosa_captivity_deseq.png", vol_pilo_capt)

ggsave(filename = "primate_climate_deseq.png", vol_prim_clim)
ggsave(filename = "primate_captivity_deseq.png", vol_prim_capt)


### Pulling Significant ASVs ###
tubuclim_sigASVs <- res_tubu_clim %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
tubucapt_sigASVs <- res_tubu_capt %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
# captivity had more ASVs of significance

piloclim_sigASVs <- res_pilo_clim %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
pilocapt_sigASVs <- res_pilo_capt %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
# comparable; climate had slightly more ASVs of significance

primclim_sigASVs <- res_prim_clim %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
primcapt_sigASVs <- res_prim_capt %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
# captivity had more ASVs of significance

