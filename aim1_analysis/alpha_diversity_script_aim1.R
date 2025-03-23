#### Alpha Diversity ######

if (!requireNamespace("picante", quietly = TRUE)) install.packages("picante")
if (!requireNamespace("ggsignif", quietly = TRUE)) install.packages("ggsignif")
if (!requireNamespace("FSA", quietly = TRUE)) install.packages("FSA")

library(FSA)  # for Dunn's test
library(phyloseq)
library(tidyverse)
library(picante)
library(ggsignif)

## To run, please replace with the order name as specified in the metadata.
order_name <- "Cetartiodactyla"

# 0. Import phyloseq_file object and save as "phyloseq")
setwd("~/Documents/UBC/MICB475/project_2/micb475-group5/aim1_analysis")
load("../preprocessing/phyloseq_file.RData")
phyloseq <- phyloseq_file


# 1. Select order of interest
phyloseq_order <- subset_samples(phyloseq_file, Taxonomy_Order == order_name)

# Add Shannon to metadata table
# Ignore warning about singletons; DADA2 does not include singletons.
shannon <- estimate_richness(phyloseq_order, measures = c("Shannon"))
sample_data(phyloseq_order)$Shannon <- shannon$Shannon

# 2. SHANNON DIVERSITY: generate boxplot of richness + evenness of samples
gg_richness <- plot_richness(phyloseq_order, x = "Climate..basic.", measures = c("Shannon")) +
  ggtitle(paste("Shannon Diversity of", order_name, "Gut Microbiome Samples Across Climates")) +
  xlab("Climate Category") +
  ylab("Shannon Diversity") +
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 0, hjust=0.5))

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
plot.pd <- ggplot(sample_data(phyloseq_order), aes(Climate..basic., PD)) + 
  geom_boxplot() +
  ggtitle(paste("Faith's Phylogenetic Diversity of", order_name, "Gut Microbiome Samples Across Climates")) +
  xlab("Climate Category") +
  ylab("Phylogenetic Diversity")

# view plot
plot.pd

#=======================================================================
#### Statistical Analysis: Wilcoxon Rank Test (non-parametric, significance of diversity differences) ######
samp_dat <- sample_data(phyloseq_order)
samp_dat_df <- data.frame(samp_dat)
# Subset the data for wild and captive groups
wild_data <- samp_dat_df[samp_dat_df$captive_wild == "wild", ]
captive_data <- samp_dat_df[samp_dat_df$captive_wild == "captive", ]

num_climates <- length(unique(samp_dat_df$Climate..basic.))

comparisons <- combn(unique(samp_dat_df$Climate..basic.), 2, simplify = FALSE)

if (num_climates == 2) {
  # Kruskal-Wallis test for Faith's Phylogenetic Diversity in the wild group
  kruskal_wild_pd <- kruskal.test(PD ~ Climate..basic., data = wild_data)
  
  # Kruskal-Wallis test for Faith's Phylogenetic Diversity in the captive group
  kruskal_captive_pd <- kruskal.test(PD ~ Climate..basic., data = captive_data)
  
  # WILD: Wilcox: Shannon Diversity
  wilcox_wild_shannon <- wilcox.test(Shannon ~ Climate..basic., data = wild_data, exact = FALSE)
  # WILD: Wilcox: Faith's PD
  wilcox_wild_pd <- wilcox.test(PD ~ Climate..basic., data = wild_data, exact = FALSE)
  # CAPTIVE: Wilcox: Shannon Diversity
  wilcox_captive_shannon <- wilcox.test(Shannon ~ Climate..basic., data = captive_data, exact = FALSE)
  # CAPTIVE: Wilcox: Faith's PD
  wilcox_captive_pd <- wilcox.test(PD ~ Climate..basic., data = captive_data, exact = FALSE)
  
  p_value_shannon <- wilcox_shannon$p.value
  p_value_pd <- wilcox_pd$p.value
  
  final_shannon_plot <- gg_richness + 
    geom_signif(comparisons = list(c("B", "C")), 
                annotations = paste("p =", format(wilcox_shannon$p.value, digits = 6)),  
                y_position = 6.5,
                tip_length = 0.03)
  
  final_pd_plot <- plot.pd + 
    geom_signif(comparisons = list(c("B", "C")), 
                annotations = paste("p =", format(wilcox_pd$p.value, digits = 6)),  
                y_position = 102,
                tip_length = 0.03)
} else {
  # Kruskal: Shannon Diversity
  kruskal_shannon <- kruskal.test(Shannon ~ Climate..basic., data = samp_dat_df)
  # Kruskal: Faith's PD
  kruskal_pd <- kruskal.test(PD ~ Climate..basic., data = samp_dat_df)
  
  p_value_shannon <- kruskal_shannon$p.value
  p_value_pd <- kruskal_pd$p.value
  
  # Dunn's test for pairwise comparisons (post-hoc analysis)
  dunn_shannon <- dunnTest(Shannon ~ Climate..basic., data = samp_dat_df, method = "bh")
  dunn_pd <- dunnTest(PD ~ Climate..basic., data = samp_dat_df, method = "bh")
  
  # Extract pairwise p-values for plotting
  pairwise_p_values_shannon <- dunn_shannon$res$P.adj
  pairwise_p_values_pd <- dunn_pd$res$P.adj
  pairwise_p_values_pd
  
  # Get max values for y-axis positioning
  max_shannon <- max(samp_dat_df$Shannon, na.rm = TRUE)
  max_pd <- max(samp_dat_df$PD, na.rm = TRUE)
  
  # Set staggered y-axis positions
  y_positions_shannon <- seq(from = max_shannon * 1.1, 
                             by = max_shannon * 0.1, 
                             length.out = length(comparisons))
  
  y_positions_pd <- seq(from = max_pd * 1.1, 
                        by = max_pd * 0.1, 
                        length.out = length(comparisons))
  
  final_shannon_plot <- gg_richness + 
    geom_signif(comparisons = comparisons, 
                annotations = sapply(pairwise_p_values_shannon, function(p) paste("p =", format(p, digits = 6))),  
                y_position = y_positions_shannon,
                tip_length = 0.03) +
    labs(
      subtitle = paste("Kruskal-Wallis p =", format(p_value_shannon, digits = 6)), size = 4)
  
  # Faith's PD Plot with pairwise and overall significance
  final_pd_plot <- plot.pd + 
    geom_signif(comparisons = comparisons, 
                annotations = sapply(pairwise_p_values_pd, function(p) paste("p =", format(p, digits = 6))),  
                y_position = y_positions_pd,
                tip_length = 0.03) +
    labs(
      subtitle = paste("Kruskal-Wallis p =", format(p_value_pd, digits = 6)), size = 4)
}

#=======================================================================
#### Add Statistical Results to Boxplots ######

final_shannon_plot
final_pd_plot


#### Output plots ######
ggsave(paste0("alpha_shannon_", order_name, "_boxplot_climates.png"),
       final_shannon_plot,
       height=4, width=6.5)

ggsave(paste0("alpha_pd_", order_name, "_boxplot_climates.png"),
       final_pd_plot,
       height=4, width=6.5)

