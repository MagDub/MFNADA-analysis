#### From example: https://www.datanovia.com/en/lessons/anova-in-r/#one-way-independent-measures

rm_anova_MF_1way_nocov <- function(meas) {
  
library(tidyverse)
library(ggpubr)
library(rstatix)
library(emmeans)
library(lsr)
library(readxl)

dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")       

# Take only subset
data_tmp <- dataMF %>%
  select(Participant, Drug, DrugCode, meas, matrix_score, PANASpost_NA) %>%
  rename(meas = meas)

# Anova computation, no covariate
tab <- anova_test(
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


# Split by pairs
data_tmp01 <- data_tmp[data_tmp$DrugCode == 0 | data_tmp$DrugCode == 1, ]
data_tmp12 <- data_tmp[data_tmp$DrugCode == 1 | data_tmp$DrugCode == 2, ]
data_tmp02 <- data_tmp[data_tmp$DrugCode == 0 | data_tmp$DrugCode == 2, ]

# Age effect size
effect_pwcD01 <-cohensD(meas ~ DrugCode, data = data_tmp01)
effect_pwcD12 <-cohensD(meas ~ DrugCode, data = data_tmp12)
effect_pwcD02 <-cohensD(meas ~ DrugCode, data = data_tmp02)


sentence1=paste(
  " (drug main effect: F(",
  tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3),
  ")") 

sentence2=paste(
  "Pairwise comparisons for drug effect (placebo vs noradrenaline: t(",
  pwc$df[3],")=", round(pwc$statistic[3],3),", p=", round(pwc$p[3],3),  ", d=", round(effect_pwcD02,3),
  "; dopamine vs placebo: t(",
  pwc$df[1],")=", round(pwc$statistic[1],3),", p=", round(pwc$p[1],3),  ", d=", round(effect_pwcD01,3),
  "; dopamine vs noradrenaline: t(",
  pwc$df[2],")=", round(pwc$statistic[2],3),", p=", round(pwc$p[2],3),  ", d=", round(effect_pwcD12,3),
  ")")

mid=paste("-------------------------------------------------------")

output_txt = c(sentence1,paste(""), mid, paste(""),sentence2)

return(output_txt)

}