BiocManager::install("microbiome")
install.packages("ggVennDiagram")
install.packages("sf")

library(tidyverse)
library(phyloseq)
library(microbiome)
library(ggVennDiagram)

load("phyloseq_file.RData")

#Core Microbiome analysis 

# Convert to relative abundance
Data_relative_abundance <- transform_sample_counts(phyloseq_file, fun=function(x) x/sum(x))

#TUB
Data_filtered_tub <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Tubulidentata")

phylo_tub_captive <- subset_samples(Data_filtered, captive_wild == "captive")
phylo_tub_wild <- subset_samples(Data_filtered, captive_wild == "wild")


phylo_tub_captive_ASVs <-core_members(phylo_tub_captive, detection=0, prevalence = 0.7)
phylo_tub_wild_ASVs <-core_members(phylo_tub_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_tub_captive_ASVs,phyloseq_file) %>%
  tax_table()

prune_taxa(phylo_tub_wild_ASVs,phyloseq_file) %>%
  tax_table()

tax_table(prune_taxa(phylo_tub_captive_ASVs,phyloseq_file))
tax_table(prune_taxa(phylo_tub_wild_ASVs,phyloseq_file))

pruned_data_tub_captive <- prune_taxa(phylo_tub_captive_ASVs, phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

pruned_data_tub_wild <- prune_taxa(phylo_tub_wild_ASVs,phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")

tub_captive_list <- core_members(phylo_tub_captive, detection=0.001, prevalence = 0.10)
tub_wild_list <- core_members(phylo_tub_wild, detection=0.001, prevalence = 0.10)
Tub_list_full <- list(captive= tub_captive_list, wild = tub_wild_list)

tub_venn <- ggVennDiagram(x = Tub_list_full)
tub_venn
ggsave("tub_venn.png", tub_venn)


#pilosa
Data_filtered_pilosa <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Pilosa")

phylo_pilosa_captive <- subset_samples(Data_filtered_pilosa, captive_wild == "captive")
phylo_pilosa_wild <- subset_samples(Data_filtered_pilosa, captive_wild == "wild")


phylo_pilosa_captive_ASVs <-core_members(phylo_pilosa_captive, detection=0, prevalence = 0.7)
phylo_pilosa_wild_ASVs <-core_members(phylo_pilosa_wild, detection=0, prevalence = 0.7)

prune_taxa(phylo_pilosa_captive_ASVs,phyloseq_file) %>%
  tax_table()

prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_file) %>%
  tax_table()

tax_table(prune_taxa(phylo_pilosa_captive_ASVs,phyloseq_file))
tax_table(prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_file))

pruned_data_pilosa_captive <- prune_taxa(phylo_pilosa_captive_ASVs, phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")
pruned_data_pilosa_captive

pruned_data_pilosa_wild <- prune_taxa(phylo_pilosa_wild_ASVs,phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")
pruned_data_pilosa_wild


pilosa_captive_list <- core_members(phylo_pilosa_captive, detection=0.001, prevalence = 0.10)
pilosa_wild_list <- core_members(phylo_pilosa_wild, detection=0.001, prevalence = 0.10)
pilosa_list_full <- list(captive= pilosa_captive_list, wild = pilosa_wild_list)

pilosa_venn <- ggVennDiagram(x = pilosa_list_full)
pilosa_venn
ggsave("pilosa_venn.png", pilosa_venn)


#PRIMATES
Data_filtered_primates <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Primates")

phylo_primates_captive <- subset_samples(Data_filtered_primates, captive_wild == "captive")
phylo_primates_wild <- subset_samples(Data_filtered_primates, captive_wild == "wild")


phylo_primates_captive_ASVs <-core_members(phylo_primates_captive, detection=0, prevalence = 0.7)
phylo_primates_wild_ASVs <-core_members(phylo_primates_wild, detection=0, prevalence = 0.10) #does not reach 0.7? 

prune_taxa(phylo_primates_captive_ASVs,phyloseq_file) %>%
  tax_table()

prune_taxa(phylo_primates_wild_ASVs,phyloseq_file) %>%
  tax_table() #STUCK HERE

tax_table(prune_taxa(phylo_primates_captive_ASVs,phyloseq_file))
tax_table(prune_taxa(phylo_primates_wild_ASVs,phyloseq_file))

pruned_data_primates_captive <- prune_taxa(phylo_primates_captive_ASVs, phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")
pruned_data_primates_captive

pruned_data_primates_wild <- prune_taxa(phylo_primates_wild_ASVs,phyloseq_file) %>%
  plot_bar(fill = "Genus") +
  facet_wrap(~ captive_wild, scales = "free")
pruned_data_primates_wild


primates_captive_list <- core_members(phylo_primates_captive, detection=0.001, prevalence = 0.10)
primates_wild_list <- core_members(phylo_primates_wild, detection=0.001, prevalence = 0.10)
primates_list_full <- list(captive= pilosa_primates_list, wild = primates_wild_list)

primates_venn <- ggVennDiagram(x = primates_list_full)
primates_venn
ggsave("primates_venn.png", primates_venn)



#OLD AND WRONG 
phylo_tubulidentata <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Tubulidentata")
phylo_pilosa <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Pilosa")
phylo_primate <- subset_samples(Data_relative_abundance, Taxonomy_Order == "Primates")


phylo_tubulidentata_ASVs <- core_members(phylo_tubulidentata, detection=0, prevalence = 0.7)
phylo_pilosa_ASVs <- core_members(phylo_pilosa, detection=0, prevalence = 0.7)
phylo_primate_ASVs<- core_members(phylo_primate, detection=0, prevalence = 0.7)

#Pruning
prune_taxa(phylo_tubulidentata_ASVs,phyloseq_file) %>%
  tax_table()

prune_taxa(phylo_pilosa_ASVs,phyloseq_file) %>%
  tax_table()

prune_taxa(phylo_primate_ASVs,phyloseq_file) %>%
  tax_table()

#Tax Tables 
tax_table(prune_taxa(phylo_tubulidentata_ASVs,phyloseq_file))
tax_table(prune_taxa(phylo_pilosa_ASVs,phyloseq_file))
tax_table(prune_taxa(phylo_primate_ASVs, phyloseq_file)) #error here 


# can plot those ASVs' relative abundance
prune_taxa(phylo_tubulidentata_ASVs,phyloseq_file) %>% 
  plot_bar(fill="Genus") + 
  facet_wrap(.~`captive_wild`, scales ="free")


prune_taxa(phylo_pilosa_ASVs,phyloseq_file) %>% 
  plot_bar(fill="Genus") + 
  facet_wrap(.~`captive_wild`, scales ="free")

prune_taxa(phylo_primate_ASVs,phyloseq_file) %>% 
  plot_bar(fill="Genus") + 
  facet_wrap(.~`captive_wild`, scales ="free")


#Venn Diagram 
tub_list <- core_members(phylo_tubulidentata, detection=0.001, prevalence = 0.10)
pilosa_list <- core_members(phylo_pilosa, detection=0.001, prevalence = 0.10)
primates_list <- core_members(phylo_primate, detection=0.001, prevalence = 0.10)

order_list_full <- list(Tubululindenata = tub_list, Pilosa = pilosa_list, Primates =primates_list)

# Create a Venn diagram using all the ASVs shared and unique to antibiotic users and non users
first_venn <- ggVennDiagram(x = order_list_full)
first_venn
ggsave("first_venn.png", first_venn)
