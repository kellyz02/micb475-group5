##### Install packages #####
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

pkgs <- c("ALDEx2", "SummarizedExperiment", "Biobase", "devtools", 
          "ComplexHeatmap", "BiocGenerics", "metagenomeSeq", 
          "Maaslin2", "edgeR", "lefser", "limma", "KEGGREST", "DESeq2")

for (pkg in pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE))
    BiocManager::install(pkg)
}

devtools::install_github("cafferychen777/ggpicrust2")

#### Load packages ####
library(readr)
library(ggpicrust2)
library(tibble)
library(tidyverse)
library(ggprism)
library(patchwork)
library(DESeq2)
library(ggh4x)

#### Import files and preparing tables ####
# Importing the pathway picrust2
abundance_file <- "pathabun_exported/pathway_abundance.tsv"
abundance_data <- read_delim(abundance_file, delim = "\t", skip = 1, col_names = TRUE, trim_ws = TRUE) %>%
  rename("#OTU ID" = "Pathway")
abundance_data  =as.data.frame(abundance_data)

#Import your metadata file, no need to filter yet
metadata <- read_delim("zoo_metadata_edited.tsv")
#Rename climate column for ease
colnames(metadata)[colnames(metadata) == "Climate (basic)"] <- "Climate_basic"

#### Subset into different pairwise comparisons ####
# CLIMATES WITHIN PRIMATES ORDER
# Filter for primates only
metadata_primates <- metadata %>% filter(Taxonomy_Order == "Primates")
# Tropical & Continental
metadata_tropical_continental <- metadata_primates %>% filter(Climate_basic %in% c("A", "D"))

#Filtering the abundance table to only include samples that are in the filtered metadata
sample_names = metadata_tropical_continental$"#SampleID" # each time we run through the code, we need to change it to the correct metadata
sample_names = append(sample_names, "Pathway")
abundance_data_filtered = abundance_data[, colnames(abundance_data) %in% sample_names] #This step is the actual filtering 

#Removing individuals with no data that caused a problem for pathways_daa()
abundance_data_filtered =  abundance_data_filtered[, colSums(abundance_data_filtered != 0) > 0]

#Ensuring the rownames for the abundance_data_filtered is empty. This is required for their functions to run.
rownames(abundance_data_filtered) = NULL

#verify samples in metadata match samples in abundance_data
abun_samples = rownames(t(abundance_data_filtered[,-1])) #Getting a list of the sample names in the newly filtered abundance data
metadata_tropical_continental = metadata_tropical_continental[metadata_tropical_continental$`#SampleID` %in% abun_samples,] #making sure the filtered metadata only includes these samples

#### DESEq ####
#Perform pathway DAA using DESEQ2 method
abundance_daa_results_df <- pathway_daa(abundance = abundance_data_filtered %>% column_to_rownames("Pathway"), 
                                        metadata = metadata_tropical_continental, group = "Climate_basic", daa_method = "DESeq2")

# Annotate MetaCyc pathway so they are more descriptive
metacyc_daa_annotated_results_df <- pathway_annotation(pathway = "MetaCyc", 
                                                       daa_results_df = abundance_daa_results_df, ko_to_kegg = FALSE)

# Filter p-values to only significant ones
feature_with_p_0.05 <- abundance_daa_results_df %>% filter(p_values < 0.05)

#Changing the pathway column to description for the results 
feature_desc = inner_join(feature_with_p_0.05,metacyc_daa_annotated_results_df, by = "feature")
feature_desc$feature = feature_desc$description
feature_desc = feature_desc[,c(1:7)]
colnames(feature_desc) = colnames(feature_with_p_0.05)

#Changing the pathway column to description for the abundance table
abundance = abundance_data_filtered %>% filter(Pathway %in% feature_with_p_0.05$feature)
colnames(abundance)[1] = "feature"
abundance_desc = inner_join(abundance,metacyc_daa_annotated_results_df, by = "feature")
abundance_desc$feature = abundance_desc$description
#this line will change for each dataset. 88 represents the number of samples in the filtered abundance table
abundance_desc = abundance_desc[,-c(88:ncol(abundance_desc))] 

# Generate a heatmap
heatmap <- pathway_heatmap(abundance = abundance_desc %>% column_to_rownames("feature"), metadata = metadata_tropical_continental, group = "Climate_basic")
heatmap

# Generate pathway PCA plot
colnames(metadata_tropical_continental)[colnames(metadata_tropical_continental) == "#SampleID"] <- "sample_name"
pca <- pathway_pca(abundance = abundance_data_filtered %>% column_to_rownames("Pathway"), metadata = metadata_tropical_continental, group = "Climate_basic")
pca

 ggsave("tropical_continental_pca.png"
       , pca
       , height=4, width=6.5)

# Generating a bar plot representing log2FC from the custom deseq2 function
# Go to the Deseq2 function script and update the metadata category of interest
# Lead the function in
source("DESeq2_function.R")

# Run the function on your own data
res =  DEseq2_function(abundance_data_filtered, metadata_tropical_continental, "Climate_basic")
res$feature =rownames(res)
res_desc = inner_join(res,metacyc_daa_annotated_results_df, by = "feature")
res_desc = res_desc[, -c(8:13)]
View(res_desc)

# Filter to only include significant pathways
sig_res = res_desc %>%
  filter(pvalue < 0.05) %>%
  filter(log2FoldChange > 2 | log2FoldChange < -2)

sig_res <- sig_res[order(sig_res$log2FoldChange),]
log2foldchange <- ggplot(data = sig_res, aes(y = reorder(description, sort(as.numeric(log2FoldChange))), x= log2FoldChange, fill = pvalue))+
  geom_bar(stat = "identity")+ 
  theme_bw()+
  labs(x = "Log2FoldChange", y="Pathways")
log2foldchange

ggsave("tropical_continental_log2foldchange.png"
       , log2foldchange
       , height=6, width=12)
