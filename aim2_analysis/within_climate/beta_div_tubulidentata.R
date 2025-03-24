# load in packages
library(vegan)
library(phyloseq)
library(ggplot2)

load("phyloseq_rare.RData")

# Subset phyloseq object to select for order.
physeq_tubulidentata <- subset_samples(phyloseq_rare, Taxonomy_Order == "Tubulidentata")

#### unweighted unifrac ####
unifrac_dm <- distance(physeq_tubulidentata, method = "unifrac")

pcoa_unifrac <- ordinate(physeq_tubulidentata, method="PCoA", distance=unifrac_dm)

gg_pcoa_unifrac <- plot_ordination(physeq_tubulidentata, pcoa_unifrac, color = "Climate..basic.", shape="captive_wild") +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class")
gg_pcoa_unifrac

# PERMANOVA to test if there are differences between samples in the unweighted unifrac distance matrix.
# extract metadata file from physeq_tubulidentata
metadata_tubulidentata <- as(sample_data(physeq_tubulidentata), "data.frame")

# PERMANOVA 
adonis2(unifrac_dm ~ `Climate..basic.`*captive_wild, data=metadata_tubulidentata)

# Re-plot beta diversity analysis with ellipses to show significant difference.
gg_pcoa_sigdif_unifrac <- plot_ordination(physeq_tubulidentata, pcoa_unifrac, color = "Climate..basic.", shape="captive_wild") +
  stat_ellipse(type = "norm") + aes(alpha = 0.5) + labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  scale_color_manual(
    values = c("A" = "#E69F00", "B" = "#56B4E9", "C" = "#009E73", "D" = "#D55E00"),
    labels = c("A" = "Tropical", "B" = "Arid", "C" = "Temperate", "D" = "Continental")
  ) + guides(alpha = "none")
gg_pcoa_sigdif_unifrac

ggsave("unifrac_pcoa_beta_div_tubulidentata.png"
       , gg_pcoa_sigdif_unifrac
       , height=7, width=9.5)

#### weighted unifrac ####
wunifrac_dm <- distance(physeq_tubulidentata, method = "wunifrac")

pcoa_wunifrac <- ordinate(physeq_tubulidentata, method="PCoA", distance=wunifrac_dm)

gg_pcoa_wunifrac <- plot_ordination(physeq_tubulidentata, pcoa_wunifrac, color = "Climate..basic.", shape="captive_wild") +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class")
gg_pcoa_wunifrac

# PERMANOVA 
adonis2(wunifrac_dm ~ `Climate..basic.`*captive_wild, data=metadata_tubulidentata)

# Re-plot beta diversity analysis with ellipses to show significant difference.
gg_pcoa_sigdif_wunifrac <- plot_ordination(physeq_tubulidentata, pcoa_wunifrac, color = "Climate..basic.", shape="captive_wild") +
  stat_ellipse(type = "norm") + aes(alpha = 0.5) + labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  scale_color_manual(
    values = c("A" = "#E69F00", "B" = "#56B4E9", "C" = "#009E73", "D" = "#D55E00"),
    labels = c("A" = "Tropical", "B" = "Arid", "C" = "Temperate", "D" = "Continental")
  ) + guides(alpha = "none")
gg_pcoa_sigdif_wunifrac

ggsave("wunifrac_pcoa_beta_div_tubulidentata.png"
       , gg_pcoa_sigdif_wunifrac
       , height=7, width=9.5)

#### jaccard ####
jaccard_dm <- distance(physeq_tubulidentata, method = "jaccard", binary = TRUE)

pcoa_jaccard <- ordinate(physeq_tubulidentata, method="PCoA", distance=jaccard_dm)

gg_pcoa_jaccard <- plot_ordination(physeq_tubulidentata, pcoa_jaccard, color = "Climate..basic.", shape="captive_wild") +
  labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class")
gg_pcoa_jaccard

adonis2(jaccard_dm ~ `Climate..basic.`*captive_wild, data=metadata_tubulidentata)

# Re-plot beta diversity analysis with ellipses to show significant difference.
gg_pcoa_sigdif_jaccard <- plot_ordination(physeq_tubulidentata, pcoa_jaccard, color = "Climate..basic.", shape="captive_wild") +
  stat_ellipse(type = "norm") + aes(alpha = 0.5) + labs(pch="Captivity Status", col = "Köppen-Geiger Climate Class") +
  scale_color_manual(
    values = c("A" = "#E69F00", "B" = "#56B4E9", "C" = "#009E73", "D" = "#D55E00"),
    labels = c("A" = "Tropical", "B" = "Arid", "C" = "Temperate", "D" = "Continental")
  ) + guides(alpha = "none")
gg_pcoa_sigdif_jaccard

ggsave("jaccard_pcoa_beta_div_tubulidentata.png"
       , gg_pcoa_sigdif_jaccard
       , height=7, width=9.5)
