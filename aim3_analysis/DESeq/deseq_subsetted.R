### DESeq based on observed significances of rarefied beta diversity results
## (w/unifrac plots for phylogenetic distance?)

library(tidyverse)
library(phyloseq)
library(DESeq2)


### Loading and prepping phyloseq object, edit file path if needed ###
load("phyloseq_file.RData")

phylo_plus1 <- transform_sample_counts(phyloseq_file, function(x) x+1)
# (untrans. phyloseq got zeros error for both climate and captivity predictors)


### Subsetting to mammalian orders (and climates) of interest ###
tubulidentata_phylo <- subset_samples(phylo_plus1,
                                      Taxonomy_Order == "Tubulidentata")
pilosa_phylo <- subset_samples(phylo_plus1,
                               Taxonomy_Order == "Pilosa") %>%
  subset_samples(Climate..basic. != "A")
primate_phylo <- subset_samples(phylo_plus1,
                                Taxonomy_Order == "Primates") %>%
  subset_samples(Climate..basic. != "B") %>%
  subset_samples(Climate..basic. != "D")


### DESeq objects and analysis ###

# only arid climate kept in rarefied beta div
tubu <- phyloseq_to_deseq2(tubulidentata_phylo, ~`captive_wild`)

# temperate and continental
pilo <- phyloseq_to_deseq2(pilosa_phylo, ~`Climate..basic.`)

# tropical and temperate
prim_clim <- phyloseq_to_deseq2(primate_phylo, ~`Climate..basic.`)
prim_capt <- phyloseq_to_deseq2(primate_phylo, ~`captive_wild`)


###

deseq_tubu <- DESeq(tubu)

deseq_pilo <- DESeq(pilo)

deseq_prim_clim <- DESeq(prim_clim)
deseq_prim_capt <- DESeq(prim_capt)

# Results tables
# note to self: reference set as earliest in alphabetical order if undefined
# e.g., "captive" status will be reference for captive-wild predictor
res_tubu <- results(deseq_tubu, tidy = TRUE)

res_pilo <- results(deseq_pilo, tidy = TRUE)
# reference climate: C (temperate)

res_prim_clim <- results(deseq_prim_clim, tidy = TRUE)
res_prim_capt <- results(deseq_prim_capt, tidy = TRUE)
# reference climate: A (tropical)


### Volcano plots ###
# tubulidentata
vol_tubu <- res_tubu %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Tubulidentata (Captive vs. Wild)")

# pilosa
vol_pilo <- res_pilo %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Pilosa (Climate)")

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
ggsave(filename = "tubulidentata_captivity_deseq.png", vol_tubu)

ggsave(filename = "pilosa_climate_deseq.png", vol_pilo)

ggsave(filename = "primate_climate_deseq.png", vol_prim_clim)
ggsave(filename = "primate_captivity_deseq.png", vol_prim_capt)


### Pulling Significant ASVs ###
tubu_sigASVs <- res_tubu %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)

pilo_sigASVs <- res_pilo %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)

primclim_sigASVs <- res_prim_clim %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
primcapt_sigASVs <- res_prim_capt %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
# captivity had more ASVs of significance

