
library(tidyverse)
library(phyloseq)
library(microbiome)
library(ggVennDiagram)

load("phyloseq_rare.RData")

Data_relative_abundance <- transform_sample_counts(phyloseq_rare, fun=function(x) x/sum(x))

##TUB## 
Data_filtered_tub <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Tubulidentata")

phylo_tub_captive <- subset_samples(Data_filtered_tub, captive_wild == "captive")
phylo_tub_wild <- subset_samples(Data_filtered_tub, captive_wild == "wild")


phylo_tub_captive_ASVs <-core_members(phylo_tub_captive, detection=0, prevalence = 0.7)
phylo_tub_wild_ASVs <-core_members(phylo_tub_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_tub_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_tub_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_tub_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_tub_wild_ASVs,phyloseq_rare))

pruned_data_tub_captive <- prune_taxa(phylo_tub_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_tub_wild <- prune_taxa(phylo_tub_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

tub_captive_list <- core_members(phylo_tub_captive, detection=0.001, prevalence = 0.10)
tub_wild_list <- core_members(phylo_tub_wild, detection=0.001, prevalence = 0.10)
Tub_list_full <- list(captive= tub_captive_list, wild = tub_wild_list)

tub_venn <- ggVennDiagram(x = Tub_list_full)
tub_venn
ggsave("tub_venn.png", tub_venn)


##PRIMATES## 
Data_filtered_primates <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Primates")

phylo_primates_captive <- subset_samples(Data_filtered_primates, captive_wild == "captive")
phylo_primates_wild <- subset_samples(Data_filtered_primates, captive_wild == "wild")


phylo_primates_captive_ASVs <-core_members(phylo_primates_captive, detection=0, prevalence = 0.7)
phylo_primates_wild_ASVs <-core_members(phylo_primates_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_primates_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_primates_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_primates_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_primates_wild_ASVs,phyloseq_rare))

pruned_data_primates_captive <- prune_taxa(phylo_primates_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_primates_wild <- prune_taxa(phylo_primates_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

primates_captive_list <- core_members(phylo_primates_captive, detection=0.001, prevalence = 0.10)
primates_wild_list <- core_members(phylo_primates_wild, detection=0.001, prevalence = 0.10)
primates_list_full <- list(captive= primates_captive_list, wild =primates_wild_list)

primates_venn <- ggVennDiagram(x = primates_list_full)
primates_venn
ggsave("primates_venn.png", primates_venn)



##PILOSA## 
Data_filtered_pilosa <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Pilosa")

phylo_pilosa_captive <- subset_samples(Data_filtered_pilosa, captive_wild == "captive")
phylo_pilosa_wild <- subset_samples(Data_filtered_pilosa, captive_wild == "wild") #Are there no wild samples in the PILOSA catagory?


phylo_pilosa_captive_ASVs <-core_members(phylo_pilosa_captive, detection=0, prevalence = 0.5)
phylo_pilosa_wild_ASVs <-core_members(phylo_pilosa_wild, detection=0, prevalence = 0.5)

prune_taxa(phylo_pilosa_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_pilosa_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_rare))

pruned_data_pilosa_captive <- prune_taxa(phylo_pilosa_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_pilosa_wild <- prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pilosa_captive_list <- core_members(phylo_pilosa_captive, detection=0.001, prevalence = 0.10)
pilosa_wild_list <- core_members(phylo_pilosa_wild, detection=0.001, prevalence = 0.10)
pilosa_list_full <- list(captive= primates_pilosa_list, wild =pilosa_wild_list)

pilosa_venn <- ggVennDiagram(x = pilosa_list_full)
pilosa_venn
ggsave("pilosa_venn.png", pilosa_venn)





##Perissodactyla## 
Data_filtered_per <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Perissodactyla")

phylo_per_captive <- subset_samples(Data_filtered_per, captive_wild == "captive")
phylo_per_wild <- subset_samples(Data_filtered_per, captive_wild == "wild")


phylo_per_captive_ASVs <-core_members(phylo_per_captive, detection=0, prevalence = 0.7)
phylo_per_wild_ASVs <-core_members(phylo_per_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_per_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_per_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_per_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_per_wild_ASVs,phyloseq_rare))

pruned_data_per_captive <- prune_taxa(phylo_per_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_per_wild <- prune_taxa(phylo_per_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

per_captive_list <- core_members(phylo_per_captive, detection=0.001, prevalence = 0.10)
per_wild_list <- core_members(phylo_per_wild, detection=0.001, prevalence = 0.10)
per_list_full <- list(captive= per_captive_list, wild =per_wild_list)

per_venn <- ggVennDiagram(x = per_list_full)
per_venn
ggsave("per_venn.png", per_venn)




##Cetartiodactyla## 
Data_filtered_cet <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Cetartiodactyla")

phylo_cet_captive <- subset_samples(Data_filtered_cet, captive_wild == "captive")
phylo_cet_wild <- subset_samples(Data_filtered_cet, captive_wild == "wild")


phylo_cet_captive_ASVs <-core_members(phylo_cet_captive, detection=0, prevalence = 0.7)
phylo_cet_wild_ASVs <-core_members(phylo_cet_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_cet_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_cet_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_cet_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_cet_wild_ASVs,phyloseq_rare))

pruned_data_cet_captive <- prune_taxa(phylo_cet_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_cet_wild <- prune_taxa(phylo_cet_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

cet_captive_list <- core_members(phylo_cet_captive, detection=0.001, prevalence = 0.10)
cet_wild_list <- core_members(phylo_cet_wild, detection=0.001, prevalence = 0.10)
cet_list_full <- list(captive= cet_captive_list, wild =cet_wild_list)

cet_venn <- ggVennDiagram(x = cet_list_full)
cet_venn
ggsave("cet_venn.png", cet_venn)



##Carnivora## 
Data_filtered_carn <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Carnivora")

phylo_carn_captive <- subset_samples(Data_filtered_carn, captive_wild == "captive")
phylo_carn_wild <- subset_samples(Data_filtered_carn, captive_wild == "wild")


phylo_carn_captive_ASVs <-core_members(phylo_carn_captive, detection=0, prevalence = 0.7)
phylo_carn_wild_ASVs <-core_members(phylo_carn_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_carn_captive_ASVs,phyloseq_rare) %>%
  tax_table()

prune_taxa(phylo_carn_wild_ASVs,phyloseq_rare) %>%
  tax_table()

tax_table(prune_taxa(phylo_carn_captive_ASVs,phyloseq_rare))
tax_table(prune_taxa(phylo_carn_wild_ASVs,phyloseq_rare))

pruned_data_carn_captive <- prune_taxa(phylo_carn_captive_ASVs, phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_carn_wild <- prune_taxa(phylo_carn_wild_ASVs,phyloseq_rare) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

carn_captive_list <- core_members(phylo_carn_captive, detection=0.001, prevalence = 0.10)
carn_wild_list <- core_members(phylo_carn_wild, detection=0.001, prevalence = 0.10)
carn_list_full <- list(captive= carn_captive_list, wild =carn_wild_list)

carn_venn <- ggVennDiagram(x = carn_list_full)
carn_venn
ggsave("carn_venn.png", carn_venn)
