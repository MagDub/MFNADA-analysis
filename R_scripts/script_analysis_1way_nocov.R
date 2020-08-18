#### From example: https://www.datanovia.com/en/lessons/anova-in-r/#one-way-independent-measures

library(tidyverse)
library(ggpubr)
library(rstatix)
library(emmeans)


dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")       

meas =  'PANASpost_NA'

# Take only subset
data_tmp <- dataMF %>%
  select(Participant, Drug, meas, matrix_score, PANASpost_NA) %>%
  rename(meas = meas)

# Anova computation, no covariate
res.aov <- anova_test(
  data = data_tmp, dv = meas, wid = Participant,
  between = Drug,
  effect.size = "pes"
)

# Pairwise comparisons
pwc <- data_tmp %>% 
  emmeans_test(
    meas ~ Drug,
    p.adjust.method = "none"
  )
pwc