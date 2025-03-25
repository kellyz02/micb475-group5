#### AIM 2 Alpha Diversity ######

if (!requireNamespace("picante", quietly = TRUE)) install.packages("picante")
if (!requireNamespace("ggsignif", quietly = TRUE)) install.packages("ggsignif")
if (!requireNamespace("FSA", quietly = TRUE)) install.packages("FSA")

library(FSA)  # for Dunn's test
library(phyloseq)
library(tidyverse)
library(picante)
library(ggsignif)

## To run, please replace with the order name as specified in the metadata.
order_name <- "Primates"

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
  theme(axis.text.x = element_text(angle = 0, hjust=0.5))

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
  scale_fill_manual(values = c("wild" = "#1b9e77", "captive" = "#d95f02"))

shannon_plot
pd_plot

#=======================================================================
#### Statistical Analysis: Wilcoxon Rank Test (non-parametric, significance of diversity differences) ######
samp_dat <- sample_data(phyloseq_order)
samp_dat_df <- data.frame(samp_dat)

num_climates <- length(unique(samp_dat_df$Climate..basic.))

if (num_climates == 2) {
  # Wilcox: Shannon Diversity
  wilcox_shannon <- wilcox.test(Shannon ~ interaction(Climate..basic., captive_wild), data = samp_dat_df, exact = FALSE)
  # Wilcox: Faith's PD
  wilcox_pd <- wilcox.test(PD ~ interaction(Climate..basic., captive_wild), data = samp_dat_df, exact = FALSE)
  
  p_value_shannon <- wilcox_shannon$p.value
  p_value_pd <- wilcox_pd$p.value
  
  shannon_plot <- shannon_plot + 
    geom_signif(comparisons = list(c("B", "C")), 
                annotations = paste("p =", format(wilcox_shannon$p.value, digits = 6)),  
                y_position = 6.5,
                tip_length = 0.03)
  
  pd_plot <- pd_plot + 
    geom_signif(comparisons = list(c("B", "C")), 
                annotations = paste("p =", format(wilcox_pd$p.value, digits = 6)),  
                y_position = 102,
                tip_length = 0.03)
} else {
  # Get the unique interaction groups used in Dunn's test
  group_levels <- unique(interaction(samp_dat_df$Climate..basic., samp_dat_df$captive_wild))
  
  # Separate wild and captive groups
  wild_groups <- grep("wild$", group_levels, value = TRUE)
  captive_groups <- grep("captive$", group_levels, value = TRUE)
  
  # Generate pairwise comparisons **only within each group**
  wild_comparisons <- combn(wild_groups, 2, simplify = FALSE)
  captive_comparisons <- combn(captive_groups, 2, simplify = FALSE)
  
  # Combine the comparisons
  comparisons <- c(wild_comparisons, captive_comparisons)
  comparisons
  
  # Check the number of comparisons
  num_comparisons <- length(comparisons)
  
  kruskal_shannon <- kruskal.test(Shannon ~ interaction(Climate..basic., captive_wild), data = samp_dat_df)
  # Kruskal: Faith's PD
  kruskal_pd <- kruskal.test(PD ~ interaction(Climate..basic., captive_wild), data = samp_dat_df)

  p_value_shannon <- kruskal_shannon$p.value
  p_value_pd <- kruskal_pd$p.value
  
  # Ensure the number of p-values corresponds to the number of comparisons
  pairwise_p_values_shannon <- dunn_shannon$res$P.adj[1:num_comparisons]
  pairwise_p_values_pd <- dunn_pd$res$P.adj[1:num_comparisons]
  pairwise_p_values_pd
  
  # Get max values for y-axis positioning
  max_shannon <- max(samp_dat_df$Shannon, na.rm = TRUE)
  max_pd <- max(samp_dat_df$PD, na.rm = TRUE)
  
  # Set staggered y-axis positions
  y_positions_shannon <- seq(from = max_shannon * 1.1, 
                             by = max_shannon * 0.1, 
                             length.out = num_comparisons)
  
  y_positions_pd <- seq(from = max_pd * 1.1, 
                        by = max_pd * 0.1, 
                        length.out = num_comparisons)
  
  # Plot Shannon Diversity with statistical comparisons
  shannon_plot <- shannon_plot + 
    geom_signif(comparisons = comparisons, 
                annotations = sapply(pairwise_p_values_shannon, function(p) paste("p =", format(p, digits = 6))),  
                y_position = y_positions_shannon,
                tip_length = 0.03) +
    labs(subtitle = paste("Kruskal-Wallis p =", format(p_value_shannon, digits = 6)), size = 4)
  
  # Plot Faith's PD with statistical comparisons
  pd_plot <- pd_plot + 
    geom_signif(comparisons = comparisons, 
                annotations = sapply(pairwise_p_values_pd, function(p) paste("p =", format(p, digits = 6))),  
                y_position = y_positions_pd,
                tip_length = 0.03) +
    labs(subtitle = paste("Kruskal-Wallis p =", format(p_value_pd, digits = 6)), size = 4)
}

#=======================================================================
#### Add Statistical Results to Boxplots ######

shannon_plot
pd_plot


#### Output plots ######
ggsave(paste0("alpha_shannon_", order_name, "_boxplot_climates.png"),
       shannon_plot,
       height=4, width=6.5)

ggsave(paste0("alpha_pd_", order_name, "_boxplot_climates.png"),
       pd_plot,
       height=4, width=6.5)


print(comparisons)
print(unique(samp_dat_df$Climate..basic.))  # Check x-axis factor levels
print(unique(interaction(samp_dat_df$Climate..basic., samp_dat_df$captive_wild)))  # Check if interactions match
pairwise_p_values_pd
pairwise_p_values_shannon

hello <- geom_signif(comparisons = comparisons, 
            annotations = sapply(pairwise_p_values_pd, function(p) paste("p =", format(p, digits = 6))),  
            y_position = y_positions_pd,
            tip_length = 0.03)

