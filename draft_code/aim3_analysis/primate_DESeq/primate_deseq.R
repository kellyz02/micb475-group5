### PRIMATE DESeq

library(tidyverse)
library(phyloseq)
library(DESeq2)


### Loading and prepping phyloseq object, edit file path if needed ###
load("phyloseq_final.RData")

phylo_plus1 <- transform_sample_counts(phyloseq_final, function(x) x+1)


### Subsetting to primate order and respective pairwise climates of interest
primate_phylo <- subset_samples(phylo_plus1,
                                Taxonomy_Order == "Primates")
primate_temperate <- subset_samples(primate_phylo,
                                    Climate..basic. == "C")

# tropical + arid
prim_AB <- subset_samples(primate_phylo,
                          Climate..basic. != "C") %>%
  subset_samples(Climate..basic. != "D")

# tropical + temperate
prim_AC <- subset_samples(primate_phylo,
                          Climate..basic. != "B") %>%
  subset_samples(Climate..basic. != "D")

# tropical + continental
prim_AD <- subset_samples(primate_phylo,
                          Climate..basic. != "B") %>%
  subset_samples(Climate..basic. != "C")

# arid + temperate
prim_BC <- subset_samples(primate_phylo,
                          Climate..basic. != "A") %>%
  subset_samples(Climate..basic. != "D")

# arid + continental
prim_BD <- subset_samples(primate_phylo,
                          Climate..basic. != "A") %>%
  subset_samples(Climate..basic. != "C")

# temperate + continental
prim_CD <- subset_samples(primate_phylo,
                          Climate..basic. != "A") %>%
  subset_samples(Climate..basic. != "B")



### DESeq objects and analysis ###
AB <- phyloseq_to_deseq2(prim_AB, ~`Climate..basic.`)
AC <- phyloseq_to_deseq2(prim_AC, ~`Climate..basic.`)
AD <- phyloseq_to_deseq2(prim_AD, ~`Climate..basic.`)
BC <- phyloseq_to_deseq2(prim_BC, ~`Climate..basic.`)
BD <- phyloseq_to_deseq2(prim_BD, ~`Climate..basic.`)
CD <- phyloseq_to_deseq2(prim_CD, ~`Climate..basic.`)
captivity <- phyloseq_to_deseq2(primate_temperate, ~`captive_wild`)

###

deseq_AB <- DESeq(AB)
deseq_AC <- DESeq(AC)
deseq_AD <- DESeq(AD)
deseq_BC <- DESeq(BC)
deseq_BD <- DESeq(BD)
deseq_CD <- DESeq(CD)
deseq_captivity <- DESeq(captivity)


### Results tables ###

#ref: tropical
res_AB <- results(deseq_AB, tidy = TRUE)
res_AC <- results(deseq_AC, tidy = TRUE)
res_AD <- results(deseq_AD, tidy = TRUE)

#ref: arid
res_BC <- results(deseq_BC, tidy = TRUE)
res_BD <- results(deseq_BD, tidy = TRUE)

#ref: temperate
res_CD <- results(deseq_CD, tidy = TRUE)

res_captivity <- results(deseq_captivity, tidy = TRUE)


### Volcano Plots ###
vol_AB <- res_AB %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Tropical vs. Arid)")
vol_AC <- res_AC %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Tropical vs. Temperate)")
vol_AD <- res_AD %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Tropical vs. Continental)")

vol_BC <- res_BC %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Arid vs. Temperate)")
vol_BD <- res_BD %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Arid vs. Continental)")

vol_CD <- res_CD %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Temperate vs. Continental)")

# in temperate climate
vol_captivity <- res_captivity %>%
  mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
  labs(title = "Differential Expression of Primates (Captive vs. Wild)")


### File Saves ###
ggsave(filename = "tropical_arid_deseq.png", vol_AB)
ggsave(filename = "tropical_temperate_deseq.png", vol_AC)
ggsave(filename = "tropical_continental_deseq.png", vol_AD)

ggsave(filename = "arid_temperate_deseq.png", vol_BC)
ggsave(filename = "arid_continental_deseq.png", vol_BD)

ggsave(filename = "temperate_continental_deseq.png", vol_CD)

ggsave(filename = "captivity_(temperate)_deseq.png", vol_captivity)


### Significant ASVs ###
AB_sigASVs <- res_AB %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
AC_sigASVs <- res_AC %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
AD_sigASVs <- res_AD %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)

BC_sigASVs <- res_BC %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
BD_sigASVs <- res_BD %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)

CD_sigASVs <- res_CD %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)

captivity_sigASVs <- res_captivity %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
