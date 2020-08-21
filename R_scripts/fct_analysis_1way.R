#### From example: https://www.datanovia.com/en/lessons/anova-in-r/#one-way-independent-measures


rm_anova_MF_1way <- function(meas) {
  
library(tidyverse)
library(ggpubr)
library(rstatix)
library(emmeans)
library(readxl)
  

  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm.xlsx")  
  
  # Remove participant 506
  dataMF <- dataMF[-c(6), ]     

# Take only subset
data_tmp <- dataMF %>%
  select(Participant, Drug, meas, matrix_score, PANASpost_NA) %>%
  rename(meas = meas)

# Summary statistics
sum_stats <- data_tmp %>%
  group_by(Drug) %>%
  get_summary_stats(meas, type = "mean_sd")

# Anova computation
tab <- anova_test(
  data = data_tmp, dv = meas, wid = Participant,
  between = Drug,
  covariate = c(matrix_score, PANASpost_NA),
  effect.size = "pes"
)

# Pairwise comparisons
pwc <- data_tmp %>% 
  emmeans_test(
    meas ~ Drug, covariate = c(matrix_score, PANASpost_NA),
    p.adjust.method = "none"
  )

sentence1=paste(
  " amisulpride, mean: ",  round(sum_stats$mean[1],2), "(", round(sum_stats$sd[1],2), ");",
  " placebo, mean: ",  round(sum_stats$mean[2],2), "(", round(sum_stats$sd[2],2), ");",
  " propranolol, mean: ",  round(sum_stats$mean[3],2), "(", round(sum_stats$sd[3],2), ");",
  " (drug main effect: F(",
  tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3),
  "; WASI main effect: F(",
  tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3),
  "; PANAS_NA main effect: F(",
  tab$DFn[2],",",tab$DFd[2],") =",round(tab$F[2],3),", p=", round(tab$p[2],3), ", pes=", round(tab$pes[2],3),
  ")") 

sentence2=paste(
  "Pairwise comparisons for drug effect (placebo vs noradrenaline: t(",
  pwc$df[3],")=", round(pwc$statistic[3],3),", p=", round(pwc$p[3],3),
  "; dopamine vs placebo: t(",
  pwc$df[1],")=", round(pwc$statistic[1],3),", p=", round(pwc$p[1],3),
  "; dopamine vs noradrenaline: t(",
  pwc$df[2],")=", round(pwc$statistic[2],3),", p=", round(pwc$p[2],3),
  ")")

mid=paste("-------------------------------------------------------")

output_txt = c(sentence1,paste(""), mid, paste(""),sentence2)

return(output_txt)

}