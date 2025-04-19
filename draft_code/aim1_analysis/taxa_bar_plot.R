#### taxa bar plot ####

library(phyloseq)
library(tidyverse)
library(ggplot2)

# import phyloseq_file object and save as "phyloseq"
load("phyloseq_file.RData")
phyloseq <- phyloseq_file

# chose taxonomic rank (phylum)
phyloseq_phylum <- tax_glom(phyloseq, taxrank = "Phylum")

# convert the phyloseq object to a data frame
phylum_df <- psmelt(phyloseq_phylum)

# plot a taxa bar plot
ggplot(phylum_df, aes(x = Climate..basic., y = Abundance, fill = Phylum)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ Taxonomy_Order) +
  xlab("Climate") +
  theme_minimal()