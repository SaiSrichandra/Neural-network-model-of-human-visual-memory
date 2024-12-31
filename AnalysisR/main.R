library(dplyr)
library(ggplot2)

# anova on binning
data_bin = read.csv(file = "Data/ObjectBinning.csv")
aov_bin = aov(counts ~ exemplars + similarity + layer, data = data_bin)
summary(aov_bin)

# compute slopes
data_firstpool = read.csv(file = "Data/Results_firstpooling.csv")
data_lastpool = read.csv(file = "Data/Results_lastpooling.csv")
similarity_levels = unique(data_firstpool$similarity)
layer_levels = unique(data_firstpool$layer)
data_slope_first = NULL
data_slope_last = NULL
for (i in 1:length(similarity_levels))
{
  for (j in 1:length(layer_levels))
  {
    data_ij_first = filter(data_firstpool, similarity == similarity_levels[i], layer == layer_levels[j])
    data_ij_last = filter(data_lastpool, similarity == similarity_levels[i], layer == layer_levels[j])
    
    lm_first = lm(accuracy ~ exemplars, data = data_ij_first)
    lm_last = lm(accuracy ~ exemplars, data = data_ij_last)
    
    summary_first = summary(lm_first)
    summary_last = summary(lm_last)
    
    print(summary_first$coefficients[2, 4])
    print(summary_last$coefficients[2, 4])
    
    data_slope_first = rbind(data_slope_first, c(summary_first$coefficients[2, "Estimate"], summary_first$coefficients[2, "Std. Error"], similarity_levels[i], layer_levels[j]))
    data_slope_last = rbind(data_slope_last, c(summary_last$coefficients[2, "Estimate"], summary_last$coefficients[2, "Std. Error"], similarity_levels[i], layer_levels[j]))
  }
}
colnames(data_slope_first) = c("slope", "se", "similarity", "layer")
colnames(data_slope_last) = c("slope", "se", "similarity", "layer")
data_slope_first = data.frame(data_slope_first)
data_slope_last = data.frame(data_slope_last)
data_slope_first$slope = round(as.numeric(data_slope_first$slope), 4)
data_slope_last$slope = round(as.numeric(data_slope_last$slope), 4)
data_slope_first$se = round(as.numeric(data_slope_first$se), 4)
data_slope_last$se = round(as.numeric(data_slope_last$se), 4)
data_slope_first$layer = factor(data_slope_first$layer, levels = c("first", "third", "fifth"))
data_slope_last$layer = factor(data_slope_last$layer, levels = c("first", "third", "fifth"))

# plot slopes
ggplot(data = data_slope_first, aes(x = layer, y = slope, fill = similarity)) +
  theme_classic(base_size = 14) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = slope - se, ymax = slope + se), position = position_dodge(0.9), width = 0.3) + 
  labs(title = "Results from the First Max Pooling Layer", x = "Layer", y = "Slope", fill = "Similarity") + 
  scale_fill_manual(labels = c("least", "medium", "most"), values = c("red", "blue", "green"))

ggplot(data = data_slope_last, aes(x = layer, y = slope, fill = similarity)) +
  theme_classic(base_size = 14) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = slope - se, ymax = slope + se), position = position_dodge(0.9), width = 0.3) + 
  labs(title = "Results from the Last Max Pooling Layer", x = "Layer", y = "Slope", fill = "Similarity") + 
  scale_fill_manual(labels = c("least", "medium", "most"), values = c("red", "blue", "green"))
