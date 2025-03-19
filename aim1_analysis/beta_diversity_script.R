### Alpha Diversity ###

# Load in required libraries and phyloseq object.
library(vegan)
library(phyloseq)
library(ggplot2)

## To run, please replace with the order name as specified in the metadata.
order_name <- "Pilosa"

# 0. Import phyloseq object and save as "phyloseq" 
load("phyloseq_file.RData")

# 1. Select order of interest
phyloseq_order <- subset_samples(phyloseq_file, Taxonomy_Order == order_name)

# 2. Bray-Curtis dissimilarity
bc_dm <- distance(phyloseq_order, method = "bray")

# 3. Visualization of Bray-Curtis using a PCoA plot
pcoa_bc <- ordinate(phyloseq_order, method="PCoA", distance=bc_dm)

gg_pcoa <- plot_ordination(phyloseq_order, pcoa_bc, color = "Climate..basic.", shape = "captive_wild") +
  labs(pch = "Captivity Status", col = "Köppen-Geiger Climate Class") +
  theme_minimal()

gg_pcoa$layers[[1]]$aes_params$alpha <- 0.8

# View plot
gg_pcoa

# 4. PERMANOVA to test if there are differences between samples in the Bray-Curtis distance matrix.
metadata_order <- as(sample_data(phyloseq_order), "data.frame")

# Run PERMANOVA on Bray-Curtis distances
permanova <- adonis2(bc_dm ~ `Climate..basic.` * captive_wild, data = metadata_order)

# Add PERMANOVA R² and p-values to metadata
sample_data(phyloseq_order)$PERMANOVA_R2 <- permanova$R2[1]  # Effect size for Climate..basic.
sample_data(phyloseq_order)$PERMANOVA_p <- permanova$Pr[1]   # p-value for Climate..basic.

# Create a results table
permanova_table <- data.frame(
  Order = order_name,   # Include the selected order
  Factor = rownames(permanova),
  R2 = permanova$R2,
  P_value = permanova$`Pr(>F)`
)

# Print the table
print(permanova_table)

# Define the filename
filename <- "PERMANOVA_results_all_orders.csv"

# Check if the file already exists
if (!file.exists(filename)) {
  # If the file doesn't exist, create it with column headers
  write.csv(permanova_table, filename, row.names = FALSE)
} else {
  # If the file exists, append the new data without headers
  write.table(permanova_table, filename, row.names = FALSE, col.names = FALSE, sep = ",", append = TRUE)
}

# 5. Re-plot beta diversity analysis with ellipses to show significant difference.
gg_pcoa_sig <- plot_ordination(phyloseq_order, pcoa_bc, color = "Climate..basic.", shape="captive_wild") +
  stat_ellipse(type = "norm") +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  theme_minimal()

gg_pcoa_sig$layers[[1]]$aes_params$alpha <- 0.8

# View plot
gg_pcoa_sig

# Output plot
ggsave(paste0("pcoa_beta_div_", order_name, "_plot.png"),
       gg_pcoa_sig,
       height=4, width=6.5)
