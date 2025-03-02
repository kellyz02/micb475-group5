#### Alpha Diversity ######

library(phyloseq)
library(tidyverse)
library(picante)
library(ggsignif)

## CHANGE HERE: to run on different orders, please just replace the value of this variable:
order_name <- "Cetartiodactyla"

# 0. Import phyloseq_file object and save as "phyloseq")
# (make sure the RData object is downloaded in your current directory)
# CHANGE HERE: setwd("/Users/kellyzhang/Documents/UBC/MICB475/project_2/micb475-group5")
load("phyloseq_file.RData")
phyloseq <- phyloseq_file

# 1. Select order of interest
phyloseq_order <- subset_samples(phyloseq_file, Taxonomy_Order == order_name)

# Add Shannon to metadata table
shannon <- estimate_richness(phyloseq_order, measures = c("Shannon"))
sample_data(phyloseq_order)$Shannon <- shannon$Shannon

# 2. SHANNON DIVERSITY: generate dotplot of richness + evenness of samples
gg_richness <- plot_richness(phyloseq_order, x = "captive_wild", measures = c("Shannon")) +
  ggtitle(paste("Shannon Diversity of Captive and Wild", order_name, "Samples")) +
  xlab("Sample ID") +
  ylab("Shannon Diversity") +
  geom_boxplot()
gg_richness

ggsave(filename = "plot_richness.png"
       , gg_richness
       , height=4, width=6)

# 3. FAITH'S PHYLOGENETIC DIVERSITY: calculate diversity taking into account
# phylogenetic diversity (i.e. does captivity impact evolutionary diversity/structure of community?)
phylo_dist <- pd(t(otu_table(phyloseq_order)), phy_tree(phyloseq_order),
                 include.root=F) 

# Add PD to metadata table
sample_data(phyloseq_order)$PD <- phylo_dist$PD

# plot any metadata category against the PD
plot.pd <- ggplot(sample_data(phyloseq_order), aes(captive_wild, PD)) + 
  geom_boxplot() +
  ggtitle(paste("Faith's Phylogenetic Diversity of Captive and Wild", order_name, "Samples")) +
  xlab("Sample ID") +
  ylab("Phylogenetic Diversity")

# view plot
plot.pd

#=======================================================================
#### Statistical Analysis: Wilcoxon Rank Test (non-parametric, significance of diversity differences) ######
samp_dat <- sample_data(phyloseq_order)
samp_dat_df <- data.frame(samp_dat)

# Wilcox: Shannon Diversity
wilcox_shannon <- wilcox.test(Shannon ~ captive_wild, data = samp_dat_df, exact = FALSE)

# Wilcox: Faith's PD
wilcox_pd <- wilcox.test(PD ~ captive_wild, data = samp_dat_df, exact = FALSE)

#=======================================================================
#### Add Statistical Results to Boxplots ######
gg_richness + 
  geom_signif(comparisons = list(c("captive", "wild")), 
              annotations = paste("p =", format(wilcox_shannon$p.value, digits = 6)),  
              y_position = 6.5,
              tip_length = 0.03)

plot.pd + 
  geom_signif(comparisons = list(c("captive", "wild")), 
              annotations = paste("p =", format(wilcox_pd$p.value, digits = 6)),  
              y_position = 102,
              tip_length = 0.03)

