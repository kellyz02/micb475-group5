library(tidyverse)
library(phyloseq)
library(indicspecies)

load("phyloseq_file.RData")

#### Indicator Species/Taxa Analysis ####
phyloseq_order_glom <- tax_glom(phyloseq_file, "Order", NArm = FALSE)
phyloseq_order_RA<- transform_sample_counts(phyloseq_order_glom, fun=function(x) x/sum(x))

#ISA
isa_phylo <- multipatt(t(otu_table(phyloseq_order_RA)), cluster = sample_data(phyloseq_order_RA)$`captive_wild`)
summary(isa_phylo)
taxtable <- tax_table(phyloseq_file) %>% as.data.frame() %>% rownames_to_column(var="ASV")

isa_phylo$sign %>%
  rownames_to_column(var="ASV") %>%
  left_join(taxtable) %>%
  filter(p.value<0.05) %>% View()
