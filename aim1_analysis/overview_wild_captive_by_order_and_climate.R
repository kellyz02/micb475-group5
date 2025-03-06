library(ggplot2)
library(phyloseq)

# load in phyloseq object
load("~/Desktop/micb475_r/PROJECT/phyloseq_file.RData")
phyloseq <- phyloseq_file

# extract metadata from phyloseq object
metadata <- as(sample_data(phyloseq), "data.frame")

# create bar plot counting the number of captive and wild animals are present in each order and climate group
gg_overview <- ggplot(metadata, aes(x = Taxonomy_Order, fill = captive_wild)) +
  geom_bar(position = "dodge") +  # Separate bars for Wild & Captive
  facet_wrap(~ Climate..basic.) +  # Separate plots for each Climate type
  labs(title = "Wild vs. Captive Animals by Order and Climate",
       x = "Order",
       y = "Count",
       fill = "Captivity Status") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

gg_overview

ggsave(filename = "wild_v_captive_animal_counts_by_order_and_climate.png"
       , gg_overview
       , height=4, width=6)
