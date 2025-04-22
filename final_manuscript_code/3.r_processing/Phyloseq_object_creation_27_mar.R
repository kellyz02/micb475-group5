library(phyloseq)
library(ape) 
library(tidyverse)
library(vegan)

metafp <- "zoo_metadata_edited.tsv"
meta <- read_delim(metafp, delim="\t")

otufp <- "feature-table.txt"
otu <- read_delim(file = otufp, delim="\t", skip=1)

taxfp <- "taxonomy.tsv"
tax <- read_delim(taxfp, delim="\t")

phylotreefp <- "tree.nwk"
phylotree <- read.tree(phylotreefp)

otu_mat <- as.matrix(otu[,-1])
rownames(otu_mat) <- otu$`#OTU ID`
OTU <- otu_table(otu_mat, taxa_are_rows = TRUE) 
class(OTU)

samp_df <- as.data.frame(meta[,-1])
rownames(samp_df)<- meta$'#SampleID'
SAMP <- sample_data(samp_df)
class(SAMP)


tax_mat <- tax %>% select(-Confidence)%>%
  separate(col=Taxon, sep="; "
           , into = c("Domain","Phylum","Class","Order","Family","Genus","Species")) %>%
  as.matrix() 
tax_mat <- tax_mat[,-1]
rownames(tax_mat) <- tax$`Feature ID`
TAX <- tax_table(tax_mat)
class(TAX)

#phyloseq object
phyloseq_file <- phyloseq(OTU, SAMP, TAX, phylotree)

otu_table(phyloseq_file)
sample_data(phyloseq_file)
tax_table(phyloseq_file)
phy_tree(phyloseq_file)

###Old filtered phyloseq object retained as a control show test for cloroplasts works###
phylsoseq_filtered_bad<- subset_taxa(phyloseq_file,  Domain == "d__Bacteria" & Class!="c__Chloroplast"& Family !="f__Mitochondria")
phylsoseq_filtered_nolow_bad <- filter_taxa(phylsoseq_filtered_bad, function(x) sum(x)>5, prune = TRUE)
phyloseq_final_bad <- prune_samples(sample_sums(phylsoseq_filtered_nolow_bad)>100, phylsoseq_filtered_nolow_bad)

tax_table_df <- data.frame(tax_table(phyloseq_final_bad))
chloroplast_check <- tax_table_df %>%
  filter(grepl("^g__Chloroplast$", Genus, ignore.case = TRUE) | 
           grepl("^s__Chloroplast$", Species, ignore.case = TRUE))
chloroplast_asvs <- rownames(chloroplast_check)
if (length(chloroplast_asvs) > 0) {
  cat("The following ASVs are labeled as chloroplasts at the genus or species level:\n")
  print(chloroplast_asvs)
} else {
  cat("No ASVs labeled as chloroplasts at the genus or species level found.\n")
}

##Good Copy phyloseq file with no chloroplasts 
phylsoseq_filtered <- subset_taxa(phyloseq_file,  Domain == "d__Bacteria" & Class!="c__Chloroplast"& Family!="f__Chloroplast"& Family !="f__Mitochondria")
phylsoseq_filtered_nolow <- filter_taxa(phylsoseq_filtered, function(x) sum(x)>5, prune = TRUE)
phyloseq_final <- prune_samples(sample_sums(phylsoseq_filtered_nolow)>100, phylsoseq_filtered_nolow)

##Check for Chlorplasts##
tax_table_df <- data.frame(tax_table(phyloseq_final))
chloroplast_check <- tax_table_df %>%
  filter(grepl("^g__Chloroplast$", Genus, ignore.case = TRUE) | 
           grepl("^s__Chloroplast$", Species, ignore.case = TRUE))
chloroplast_asvs <- rownames(chloroplast_check)
if (length(chloroplast_asvs) > 0) {
  cat("The following ASVs are labeled as chloroplasts at the genus or species level:\n")
  print(chloroplast_asvs)
} else {
  cat("No ASVs labeled as chloroplasts at the genus or species level found.\n")
}

##Check for Mitochondria##
tax_table_df <- data.frame(tax_table(phyloseq_final))
Mitochondria_check <- tax_table_df %>%
  filter(grepl("^g__Mitochondria$", Genus, ignore.case = TRUE) | 
           grepl("^s__Mitochondria$", Species, ignore.case = TRUE))
Mitochondria_asvs <- rownames(Mitochondria_check)
if (length(Mitochondria_asvs) > 0) {
  cat("The following ASVs are labeled as mitochondria at the genus or species level:\n")
  print(chloroplast_asvs)
} else {
  cat("No ASVs labeled as mitochondria at the genus or species level found.\n")
}

rarecurve(t(as.data.frame(otu_table(phyloseq_final))), cex=0.1)
phyloseq_rare <- rarefy_even_depth(phyloseq_final, rngseed = 1, sample.size = 38348)


save(phyloseq_final, file="phyloseq_final.RData")
save(phyloseq_rare, file="phyloseq_rare.RData")

