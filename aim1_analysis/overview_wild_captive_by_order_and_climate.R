library(ggplot2)
library(phyloseq)

# load in phyloseq object
load("../preprocessing/phyloseq_file.RData")
phyloseq <- phyloseq_file

# extract metadata from phyloseq object
metadata <- as(sample_data(phyloseq), "data.frame")

# Create table

# Get all combinations of Order, Climate, and Captivity
all_combinations <- expand.grid(
  Taxonomy_Order = unique(metadata$Taxonomy_Order),
  Climate..basic. = unique(metadata$Climate..basic.),
  captive_wild = unique(metadata$captive_wild)
)

# Count occurrences, ensuring all combinations are included
summary_table <- metadata %>%
  count(Taxonomy_Order, Climate..basic., captive_wild) %>%
  full_join(all_combinations, by = c("Taxonomy_Order", "Climate..basic.", "captive_wild")) %>%
  mutate(n = replace_na(n, 0)) %>%  # Fill missing counts with 0
  pivot_wider(
    names_from = c(Climate..basic., captive_wild),
    values_from = n,
    values_fill = list(n = 0)
  ) %>%
  arrange(Taxonomy_Order)  # Sort rows by Order

summary_table <- summary_table %>%
  select(Taxonomy_Order, sort(colnames(.)))

write.csv(summary_table, "captivity_climate_animal_counts.csv", row.names = FALSE)



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
