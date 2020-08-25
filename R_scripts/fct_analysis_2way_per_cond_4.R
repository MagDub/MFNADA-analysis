# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_scondtH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_per_cond_4 <- function(x1, x2, x3, x4, file_) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)

  #x1 <-'pickedhigh_AB_mean'
  #x2 <-'pickedhigh_ABD_mean'
  #x3 <-'pickedhigh_BD_mean'
  #x4 <-'pickedhigh_AD_mean'
  
  dataMF <- read_excel(file_)  
  
  # Remove participant 506
  dataMF <- dataMF[-c(6), ]
  
  # Take only subset: concatenate the ones we want
  data_tmp <- dataMF[c("ID", "matrix_score", "PANASpost_NA", x1, x2, x3, x4)]
  
  # Change from wide to long format
  data_tmp_all <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x1), all_of(x2), all_of(x3), all_of(x4)) %>%
    convert_as_factor(ID, cond)
  
  # Summary statistics
  sum_stats <- data_tmp_all %>%
    group_by(cond) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp_all, dv = freq, wid = ID,
    within = cond,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp_all %>%
    pairwise_t_test(freq ~ cond, paired = TRUE, p.adjust.method = "none")
  
  
  # Split by pairs
  data_tmp_x12 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x1), all_of(x2)) %>%
    convert_as_factor(ID, cond)
  
  data_tmp_x13 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x1), all_of(x3)) %>%
    convert_as_factor(ID, cond)
  
  data_tmp_x14 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x1), all_of(x4)) %>%
    convert_as_factor(ID, cond)
  
  data_tmp_x23 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x2), all_of(x3)) %>%
    convert_as_factor(ID, cond)
  
  data_tmp_x24 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x2), all_of(x4)) %>%
    convert_as_factor(ID, cond)
  
  data_tmp_x34 <- data_tmp %>%
    gather(key = "cond", value = "freq", all_of(x3), all_of(x4)) %>%
    convert_as_factor(ID, cond)
  
  levels(data_tmp_x12$cond)
  
  # condition effect size
  effect_pwcH_x12 <-cohensD(freq ~ cond, data = data_tmp_x12, method = "paired")
  effect_pwcH_x13 <-cohensD(freq ~ cond, data = data_tmp_x13, method = "paired")
  effect_pwcH_x14 <-cohensD(freq ~ cond, data = data_tmp_x14, method = "paired")
  effect_pwcH_x23 <-cohensD(freq ~ cond, data = data_tmp_x23, method = "paired")
  effect_pwcH_x24 <-cohensD(freq ~ cond, data = data_tmp_x24, method = "paired")
  effect_pwcH_x34 <-cohensD(freq ~ cond, data = data_tmp_x34, method = "paired")
  
  sentence1=paste(
    " (condition main effect: F(", 
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3), 
    ")") 
  
  sentence2=paste(
    "Variables; 1=", x1, "2=", x2, "3=", x3, "4=", x4)
  
  sentence3=paste(
    "Pairwise comparisons for condition effect 
    (  1 vs 2: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3), ", d=", round(effect_pwcH_x12,3),
    "; 1 vs 3: t(",
    pwcH$n1[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3), ", d=", round(effect_pwcH_x13,3),
    "; 1 vs 4: t(",
    pwcH$n1[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3), ", d=", round(effect_pwcH_x14,3),
    "; 2 vs 3: t(",
    pwcH$n1[5],")=", round(pwcH$statistic[5],3),", p=", round(pwcH$p[5],3), ", d=", round(effect_pwcH_x23,3),
    "; 2 vs 4: t(",
    pwcH$n1[4],")=", round(pwcH$statistic[4],3),", p=", round(pwcH$p[4],3), ", d=", round(effect_pwcH_x24,3),
    "; 3 vs 4: t(",
    pwcH$n1[6],")=", round(pwcH$statistic[6],3),", p=", round(pwcH$p[6],3), ", d=", round(effect_pwcH_x34,3),
    ")")
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""),sentence2,mid, paste(""),sentence3,paste(""), mid)
  
  return(output_txt)
}

