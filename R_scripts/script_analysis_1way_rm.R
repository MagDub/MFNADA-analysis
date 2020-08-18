#### From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

library(car)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(readxl)

dataMF <- read_excel("GoogleDrive/UCL/MF/excels/data_for_R_measures_test_2.xlsx")       

# Take only subset
consist <- dataMF[c("Participant", "consistent_SH", "consistent_LH")]

# Change from wide to long format
consist <- consist %>%
  gather(key = "hor", value = "freq", consistent_SH, consistent_LH) %>%
  convert_as_factor(Participant, hor)

# Summary statistics
consist %>%
  group_by(hor) %>%
  get_summary_stats(freq, type = "mean_sd")

# Visualisation
bxp <- ggboxplot(consist, x = "hor", y = "freq", add = "point")
bxp

# Anova computation
res.aov <- anova_test(data = consist, dv = freq, wid = Participant, within = hor)
get_anova_table(res.aov)

# ges: generalised effect size
