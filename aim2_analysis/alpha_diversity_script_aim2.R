#### AIM 2 Alpha Diversity ######

if (!requireNamespace("picante", quietly = TRUE)) install.packages("picante")
if (!requireNamespace("ggsignif", quietly = TRUE)) install.packages("ggsignif")
if (!requireNamespace("FSA", quietly = TRUE)) install.packages("FSA")
if (!requireNamespace("rstatix", quietly = TRUE)) install.packages("rstatix")

library(FSA)  # for Dunn's test
library(phyloseq)
library(tidyverse)
library(picante)
library(ggsignif)
library(rstatix)  

## To run, please replace with the order name as specified in the metadata.
order_name <- "Perissodactyla"

# 0. Import phyloseq_file object and save as "phyloseq")
setwd("~/Documents/UBC/MICB475/project_2/micb475-group5/aim2_analysis")
load("../preprocessing/phyloseq_rare.RData")
phyloseq <- phyloseq_rare

# 1. Select order of interest
phyloseq_order <- subset_samples(phyloseq_rare, Taxonomy_Order == order_name)

# Add Shannon to metadata table
# Ignore warning about singletons; DADA2 does not include singletons.
shannon <- estimate_richness(phyloseq_order, measures = c("Shannon"))
sample_data(phyloseq_order)$Shannon <- shannon$Shannon

# 2. SHANNON DIVERSITY: generate boxplot of richness + evenness of samples
shannon_plot <- ggplot(sample_data(phyloseq_order), aes(x = Climate..basic., y = Shannon, fill = captive_wild)) +
  geom_boxplot() +
  ggtitle(paste("Shannon Diversity of", order_name, "Gut Microbiome Samples Across Climates")) +
  xlab("Climate Category") +
  ylab("Shannon Diversity") +
  scale_fill_manual(values = c("wild" = "#1b9e77", "captive" = "#d95f02")) + # Custom colors
  theme(axis.text.x = element_text(angle = 0, hjust=0.5)) + 
  ylim(min(sample_data(phyloseq_order)$Shannon) - 0.05, max(sample_data(phyloseq_order)$Shannon) * 1.1)

shannon_plot


# 3. FAITH'S PHYLOGENETIC DIVERSITY: calculate diversity taking into account
# phylogenetic diversity (i.e. does captivity impact evolutionary diversity/structure of community?)
phylo_dist <- pd(t(otu_table(phyloseq_order)), phy_tree(phyloseq_order),
                 include.root=F) 

# Add PD to metadata table
sample_data(phyloseq_order)$PD <- phylo_dist$PD

# plot any metadata category against the PD
pd_plot <- ggplot(sample_data(phyloseq_order), aes(x = Climate..basic., y = PD, fill = captive_wild)) +
  geom_boxplot() +
  ggtitle(paste("Faith's Phylogenetic Diversity of", order_name, "Gut Microbiome Samples Across Climates")) +
  xlab("Climate Category") +
  ylab("Phylogenetic Diversity") +
  scale_fill_manual(values = c("wild" = "#1b9e77", "captive" = "#d95f02")) + 
  ylim(min(sample_data(phyloseq_order)$PD) - 0.05, max(sample_data(phyloseq_order)$PD) * 1.1)

shannon_plot
pd_plot

#=======================================================================
# # 4. Calculate Kruskal-Wallis of wild vs captivity status across the climates. 
samp_dat <- sample_data(phyloseq_order)
samp_dat_df <- data.frame(samp_dat)

# kruskal_shannon_captivity <- kruskal.test(Shannon ~ captive_wild, data = samp_dat_df)
# kruskal_fd_captivity <- kruskal.test(PD ~ captive_wild, data = samp_dat_df)
# 
# # Extract p-value
# kruskal_shannon_p_value <- signif(kruskal_shannon_captivity$p.value, digits = 3)
# kruskal_fd_p_value <- signif(kruskal_fd_captivity$p.value, digits = 3)
# 
# # Add Kruskal-Wallis annotation on boxplots
# shannon_plot <- shannon_plot +
#   labs(subtitle = paste("Kruskal-Wallis (wild vs captive across climates) p=", format(kruskal_shannon_p_value, digits = 6)), size = 4)
# 
# pd_plot <- pd_plot +
#   labs(subtitle = paste("Kruskal-Wallis (wild vs captive across climates) p=", format(kruskal_fd_p_value, digits = 6)), size = 4)
# 
# 
# # 5. CALCULATE DUNN'S PAIRWISE COMPARISONS
# # Run Dunn's test
# dunn_shannon <- dunnTest(Shannon ~ interaction(Climate..basic., captive_wild), data = samp_dat_df, method = "bh")
# dunn_pd <- dunnTest(PD ~ interaction(Climate..basic., captive_wild), data = samp_dat_df, method = "bh")
# dunn_shannon_results <- dunn_shannon$res
# dunn_pd_results <- dunn_pd$res
# dunn_shannon_results$Test <- "DUNN Shannon"
# dunn_pd_results$Test <- "DUNN PD"
# # #=======================================================================
#### Statistical Analysis: Wilcoxon Rank Test (non-parametric, significance of diversity differences) ######

# # Subset the data for the two specific groups
subset_rows <- samp_dat_df[samp_dat_df$captive_wild == "captive", ]

# Perform the Wilcoxon test
wilcox_shannon <- wilcox.test(Shannon ~ Climate..basic., data = subset_rows, exact = FALSE)
wilcox_shannon_results <- data.frame(
  Comparison = "C.captive - D. captive", Z = NA, P.unadj = NA, P.adj = wilcox_shannon$p.value, Test="WILCOX Shannon"
)

wilcox_pd <- wilcox.test(PD ~ Climate..basic., data = subset_rows, exact = FALSE)
wilcox_pd_results <- data.frame(
  Comparison = "C.captive - D. captive", Z = NA, P.unadj = NA, P.adj = wilcox_pd$p.value, Test="WILCOX PD"
)

# combined_significances <- rbind(dunn_shannon_results, dunn_pd_results, wilcox_shannon_results, wilcox_pd_results)
combined_significances <- rbind(wilcox_shannon_results, wilcox_pd_results)
combined_significances$P.adj <- format(combined_significances$P.adj, scientific = FALSE)
significances_file_name <- paste0("alpha_diversity/", order_name, "_significances.csv")
write.csv(combined_significances, file = significances_file_name, row.names = FALSE)
combined_significances

############ FOR PILOSA
# #### Statistical Analysis: Wilcoxon Rank Test (non-parametric, significance of diversity differences) ######
# # Perform the Wilcoxon test
# samp_dat <- sample_data(phyloseq_order)
# samp_dat_df <- data.frame(samp_dat)
# 
# wilcox_shannon <- wilcox.test(Shannon ~ Climate..basic., data = samp_dat_df, exact = FALSE)
# wilcox_shannon_results <- data.frame(
#   Comparison = "C.captive - D.captive", Z = NA, P.unadj = NA, P.adj = wilcox_shannon$p.value, Test="WILCOX Shannon"
# )
# 
# wilcox_pd <- wilcox.test(PD ~ Climate..basic., data = samp_dat_df, exact = FALSE)
# wilcox_pd_results <- data.frame(
#   Comparison = "C.captive - D.captive", Z = NA, P.unadj = NA, P.adj = wilcox_pd$p.value, Test="WILCOX PD"
# )
# 
# combined_significances <- rbind(wilcox_shannon_results, wilcox_pd_results)
# combined_significances$P.adj <- format(combined_significances$P.adj, scientific = FALSE)
# significances_file_name <- paste0("alpha_diversity/", order_name, "_significances.csv")
# write.csv(combined_significances, file = significances_file_name, row.names = FALSE)
#=======================================================================
#### Add Statistical Results to Boxplots ######

shannon_plot
pd_plot

#### Output plots ######
ggsave(paste0("alpha_diversity/alpha_shannon_", order_name, "_boxplot_climates.png"),
       shannon_plot,
       height=4, width=6.5)

ggsave(paste0("alpha_diversity/alpha_pd_", order_name, "_boxplot_climates.png"),
       pd_plot,
       height=4, width=6.5)


