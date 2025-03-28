### Beta Diversity ###

# Load in required libraries and phyloseq object.
library(vegan)
library(phyloseq)
library(ggplot2)

## To run, please replace with the order name as specified in the metadata.
order_name <- "Cetartiodactyla"

# 0. Import rarefied phyloseq object and save as "phyloseq_rare"
load("../phyloseq_rare.RData")

# 1. Select order of interest
phyloseq_order <- subset_samples(phyloseq_rare, Taxonomy_Order == order_name)

# 2. Unweighted Unifrac
unifrac_dm <- distance(phyloseq_order, method = "unifrac")

# 3. Visualization of Unweighted Unifrac using a PCoA plot
pcoa_unifrac <- ordinate(phyloseq_order, method="PCoA", distance=unifrac_dm)

# ellipses
gg_pcoa_ellipses <- plot_ordination(phyloseq_order, pcoa_unifrac, color = "Climate..basic.", shape = "captive_wild") +
  aes(alpha = 0.5) + stat_ellipse() +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  scale_color_manual(
    values = c("A" = "#E69F00", "B" = "#56B4E9", "C" = "#009E73", "D" = "#D55E00"),
    labels = c("A" = "Tropical", "B" = "Arid", "C" = "Temperate", "D" = "Continental")
  ) + 
  guides(alpha = "none") +
  theme_minimal()
gg_pcoa_ellipses

# no ellipses
gg_pcoa <- plot_ordination(phyloseq_order, pcoa_unifrac, color = "Climate..basic.", shape = "captive_wild") +
  aes(alpha = 0.5) +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  scale_color_manual(
    values = c("A" = "#E69F00", "B" = "#56B4E9", "C" = "#009E73", "D" = "#D55E00"),
    labels = c("A" = "Tropical", "B" = "Arid", "C" = "Temperate", "D" = "Continental")
  ) + 
  guides(alpha = "none") +
  theme_minimal()
gg_pcoa

# Output plot
ggsave(paste0("unifrac_pcoa_ellipses_", order_name, ".jpg"),
       gg_pcoa_ellipses,
       height=4, width=6.5)

ggsave(paste0("unifrac_pcoa_", order_name, ".jpg"),
       gg_pcoa,
       height=4, width=6.5)

# 4. PERMANOVA to test if there are differences between samples in the weighted unifrac distance matrix.
metadata_order <- as(sample_data(phyloseq_order), "data.frame")

# Run PERMANOVA on Unweighted Unifrac distances
# a) How do climate category and captivity status influence microbial composition, independently?
permanova_by_terms <- adonis2(unifrac_dm ~ `Climate..basic.` * captive_wild, data = metadata_order,
                              by ="terms")
permanova_by_terms

# b) How does the interaction of climate category and captivity status influence microbial composition?
permanova_by_margin <- adonis2(unifrac_dm ~ `Climate..basic.` * captive_wild, data = metadata_order,
                               by ="margin")
permanova_by_margin

## PILOSA ONLY: Rarefied data has only captive animals. PERMANOVA can only be run on Climate..basic. data.
permanova_pilosa <- adonis2(unifrac_dm ~ `Climate..basic.`, data = metadata_order,
                            by =NULL)
permanova_pilosa

## TUBULIDENTATA ONLY: Rarefied data has only animals in climate B. PERMANOVA can only be run on captive_wild.
permanova_tub <- adonis2(unifrac_dm ~ `captive_wild`, data = metadata_order,
                         by =NULL)
permanova_tub

# c) Add PERMANOVA R² and p-values to metadata
# Extract R² and p-values for each term from the "by = terms" model
sample_data(phyloseq_order)$PERMANOVA_R2_Climate <- permanova_by_terms$R2[1]  # R² for Climate..basic.
sample_data(phyloseq_order)$PERMANOVA_p_Climate <- permanova_by_terms$`Pr(>F)`[1]  # p-value for Climate..basic.
sample_data(phyloseq_order)$PERMANOVA_R2_Captive <- permanova_by_terms$R2[2]  # R² for captive_wild
sample_data(phyloseq_order)$PERMANOVA_p_Captive <- permanova_by_terms$`Pr(>F)`[2]  # p-value for captive_wild
sample_data(phyloseq_order)$PERMANOVA_R2_Interaction <- permanova_by_terms$R2[3]  # R² for interaction
sample_data(phyloseq_order)$PERMANOVA_p_Interaction <- permanova_by_terms$`Pr(>F)`[3]  # p-value for interaction

# Extract R² and p-values from "by = margin" model (interaction of Climate and Captivity)
sample_data(phyloseq_order)$PERMANOVA_R2_Margin <- permanova_by_margin$R2[1]  # R² for interaction term (Climate..basic. * captive_wild)
sample_data(phyloseq_order)$PERMANOVA_p_Margin <- permanova_by_margin$`Pr(>F)`[1]  # p-value for the interaction term

# PILOSA ONLY: Extract R² and p-values from pilosa model.
sample_data(phyloseq_order)$PERMANOVA_R2_Climate <- permanova_pilosa$R2[1] 
sample_data(phyloseq_order)$PERMANOVA_p_Climate <- permanova_pilosa$`Pr(>F)`[1]

# TUBULIDENTATA ONLY: Extract R² and p-values from tub model.
sample_data(phyloseq_order)$PERMANOVA_R2_Captive <- permanova_tub$R2[1] 
sample_data(phyloseq_order)$PERMANOVA_p_Captive <- permanova_tub$`Pr(>F)`[1]

# d) Create a results table with the R² and p-values
permanova_table <- data.frame(
  Order = order_name,
  Factor = c("Climate..basic.", "captive_wild", "Climate..basic.:captive_wild"),
  R2 = c(permanova_by_terms$R2[1], permanova_by_terms$R2[2], permanova_by_terms$R2[3]),
  P_value = c(permanova_by_terms$`Pr(>F)`[1], permanova_by_terms$`Pr(>F)`[2], permanova_by_terms$`Pr(>F)`[3])
)

## PILOSA ONLY:
permanova_table <- data.frame(
  Order = order_name,
  Factor = c("Climate..basic."),
  R2 = c(permanova_pilosa$R2[1]),
  P_value = c(permanova_pilosa$`Pr(>F)`[1])
)

## TUBULIDENTATA ONLY:
permanova_table <- data.frame(
  Order = order_name,
  Factor = c("captive_wild"),
  R2 = c(permanova_tub$R2[1]),
  P_value = c(permanova_tub$`Pr(>F)`[1])
)

# Print the table of results
print(permanova_table)

# e) Define the filename for the results
filename <- "PERMANOVA_results_unifrac.csv"

# Create a table with only Order name, Factor, R², and p-value
permanova_results_reduced <- data.frame(
  Order = permanova_table$Order, 
  Factor = permanova_table$Factor, 
  R2 = permanova_table$R2, 
  P_value = permanova_table$P_value
)

# Check if the file already exists
if (!file.exists(filename)) {
  # If the file doesn't exist, create it with column headers
  write.csv(permanova_results_reduced, filename, row.names = FALSE)
} else {
  # If the file exists, append the new data without headers
  write.table(permanova_results_reduced, filename, row.names = FALSE, col.names = FALSE, sep = ",", append = TRUE)
}

