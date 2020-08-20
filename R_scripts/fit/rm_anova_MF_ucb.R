

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_ucb <- function(x1, x2) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)
  
  #x1 <- 'xi_short'
  #x2 <- 'xi_long'
  
  dataMF <- read_excel("~/MFnada/data/modelfit/ucb_prior1normal/concatenated/model_parameters.xlsx")
  
  # Remove participant 506
  dataMF <- dataMF[-c(6), ]
  
  # Take only subset: concatenate the ones we want
  data_tmp <- dataMF
  
  # Change from wide to long format
  data_tmp <- data_tmp %>%
    gather(key = "hor", value = "freq", x1, x2) %>%
    convert_as_factor(ID, hor)
  
  # Summary statistics
  data_tmp %>%
    group_by(hor, drug_code) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = ID,
    within = hor,
    between = drug_code,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp %>%
    group_by(drug_code) %>%
    pairwise_t_test(freq ~ hor, paired = TRUE, p.adjust.method = "none")
  
  # Pairwise comparisons
  pwcD <- data_tmp %>%
    pairwise_t_test(freq ~ drug_code, paired = FALSE, pool.sd = FALSE, p.adjust.method = "none")
  
  # Pairwise comparisons
  pwcHD <- data_tmp %>%
    group_by(hor) %>%
    pairwise_t_test(freq ~ drug_code, paired = FALSE, pool.sd = FALSE, p.adjust.method = "none")
  
  # Split by group
  data_tmp0 <- data_tmp[data_tmp$drug_code == 0, ]
  data_tmp1 <- data_tmp[data_tmp$drug_code == 1, ]
  data_tmp2 <- data_tmp[data_tmp$drug_code == 2, ]
  
  # Split by pairs
  data_tmp01 <- data_tmp[data_tmp$drug_code == 0 | data_tmp$drug_code == 1, ]
  data_tmp12 <- data_tmp[data_tmp$drug_code == 1 | data_tmp$drug_code == 2, ]
  data_tmp02 <- data_tmp[data_tmp$drug_code == 0 | data_tmp$drug_code == 2, ]
  
  # Age effect size
  effect_pwcD01 <-cohensD(freq ~ drug_code, data = data_tmp01)
  effect_pwcD12 <-cohensD(freq ~ drug_code, data = data_tmp12)
  effect_pwcD02 <-cohensD(freq ~ drug_code, data = data_tmp02)
  
  # Horizon effect size
  effect_pwcH0 <-cohensD(freq ~ hor, data = data_tmp0, method = "paired")
  effect_pwcH1 <-cohensD(freq ~ hor, data = data_tmp1, method = "paired")
  effect_pwcH2 <-cohensD(freq ~ hor, data = data_tmp2, method = "paired")
  
  sentence1=paste(
    " (horizon main effect: F(", 
    tab$DFn[4],",",tab$DFd[4],")=",round(tab$F[4],3),", p=", round(tab$p[4],3), ", pes=", round(tab$pes[4],3), 
    "; drug main effect: F(",
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3),
    "; drug-by-horizon interaction: F(",
    tab$DFn[7],",",tab$DFd[7],")=",round(tab$F[7],3),", p=", round(tab$p[7],3), ", pes=", round(tab$pes[7],3),
    "; WASI main effect: F(",
    tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3),
    "; WASI-by-horizon interaction: F(",
    tab$DFn[5],",",tab$DFd[5],") =",round(tab$F[5],3),", p=", round(tab$p[5],3), ", pes=", round(tab$pes[5],3),
    "; PANAS_NA main effect: F(",
    tab$DFn[2],",",tab$DFd[2],") =",round(tab$F[2],3),", p=", round(tab$p[2],3), ", pes=", round(tab$pes[2],3),
    "; PANAS_NA-by-horizon interaction: F(",
    tab$DFn[6],",",tab$DFd[6],") =",round(tab$F[6],3),", p=", round(tab$p[6],3), ", pes=", round(tab$pes[6],3),
    ")") 
  
  sentence2=paste(
    "Pairwise comparisons for horizon effect (placebo: t(",
    pwcH$n1[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3), ", d=", round(effect_pwcH0,3),
    "; noradrenaline: t(",
    pwcH$n1[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3), ", d=", round(effect_pwcH2,3),
    "; dopamine: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3), ", d=", round(effect_pwcH1,3),
    ")")
  
  sentence3=paste(
    "Pairwise comparisons for drug effect (placebo vs noradrenaline: t(",
    pwcD$n1[3],")=", round(pwcD$statistic[3],3),", p=", round(pwcD$p[3],3), ", d=", round(effect_pwcD02,3),
    "; dopamine vs placebo: t(",
    pwcD$n1[1],")=", round(pwcD$statistic[1],3),", p=", round(pwcD$p[1],3), ", d=", round(effect_pwcD01,3),
    "; dopamine vs noradrenaline: t(",
    pwcD$n1[2],")=", round(pwcD$statistic[2],3),", p=", round(pwcD$p[2],3), ", d=", round(effect_pwcD12,3),
    ")")
  
  sentence4=paste(
    "Pairwise comparisons for horizon x drug effect: ", 
    " short horizon: ", 
    "(placebo vs noradrenaline: t(",
    pwcHD$n1[6],")=", round(pwcHD$statistic[6],3),", p=", round(pwcHD$p[6],3),
    "; dopamine vs placebo: t(",
    pwcHD$n1[4],")=", round(pwcHD$statistic[4],3),", p=", round(pwcHD$p[4],3),
    "; dopamine vs noradrenaline: t(",
    pwcHD$n1[5],")=", round(pwcHD$statistic[5],3),", p=", round(pwcHD$p[5],3),
    " long horizon: ", 
    "(placebo vs noradrenaline: t(",
    pwcHD$n1[3],")=", round(pwcHD$statistic[3],3),", p=", round(pwcHD$p[3],3),
    "; dopamine vs placebo: t(",
    pwcHD$n1[1],")=", round(pwcHD$statistic[1],3),", p=", round(pwcHD$p[1],3),
    "; dopamine vs noradrenaline: t(",
    pwcHD$n1[2],")=", round(pwcHD$statistic[2],3),", p=", round(pwcHD$p[2],3),
    ")) ")
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""),sentence2,paste(""), mid, paste(""),sentence3,paste(""), mid, paste(""),sentence4)
  
  return(output_txt)
}

