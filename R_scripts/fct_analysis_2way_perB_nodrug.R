# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_perB_nodrug <- function(x1, x2, x3, x4) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)
  
  x1 <- 'RT_high_value_meanperH'
  x2 <- 'RT_medium_value_meanperH'
  x3 <- 'RT_novel_value_meanperH'
  x4 <- 'RT_low_value_meanperH'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")    
  
  # Change from wide to long format
  data_tmp <- dataMF %>%
    gather(key = "bandit", value = "freq", x1, x2, x3, x4) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp12 <- dataMF %>%
    gather(key = "bandit", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp13 <- dataMF %>%
    gather(key = "bandit", value = "freq", x1, x3) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp14 <- dataMF %>%
    gather(key = "bandit", value = "freq", x1, x4) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp23 <- dataMF %>%
    gather(key = "bandit", value = "freq", x2, x3) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp24 <- dataMF %>%
    gather(key = "bandit", value = "freq", x2, x4) %>%
    convert_as_factor(Participant, bandit)
  
  # Change from wide to long format
  data_tmp34 <- dataMF %>%
    gather(key = "bandit", value = "freq", x3, x4) %>%
    convert_as_factor(Participant, bandit)
  
  # Summary statistics
  data_tmp %>%
    group_by(bandit) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = bandit,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcB <- data_tmp %>%
    pairwise_t_test(freq ~ bandit, paired = TRUE, p.adjust.method = "none")
  
  # Bandit effect size
  effect_B12 <-cohensD(freq ~ bandit, data = data_tmp12, method = "paired")
  effect_B13 <-cohensD(freq ~ bandit, data = data_tmp13, method = "paired")
  effect_B14 <-cohensD(freq ~ bandit, data = data_tmp14, method = "paired")
  effect_B23 <-cohensD(freq ~ bandit, data = data_tmp23, method = "paired")
  effect_B24 <-cohensD(freq ~ bandit, data = data_tmp24, method = "paired")
  effect_B34 <-cohensD(freq ~ bandit, data = data_tmp34, method = "paired")
  
  #x1 <- 'RT_high_value_meanperH'
  #x2 <- 'RT_medium_value_meanperH'
  #x3 <- 'RT_novel_value_meanperH'
  #x4 <- 'RT_low_value_meanperH'
  
  sentence1=paste(
    " (bandit main effect: F(", 
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3), 
    "; WASI main effect: F(",
    tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3),
    "; PANAS_NA main effect: F(",
    tab$DFn[2],",",tab$DFd[2],") =",round(tab$F[2],3),", p=", round(tab$p[2],3), ", pes=", round(tab$pes[2],3),
    ")") 
  
  sentence2=paste(
    "Pairwise comparisons for bandit effect (high vs low: t(",
    pwcB$n1[1],")=", round(pwcB$statistic[1],3),", p=", round(pwcB$p[1],3), ", d=", round(effect_B14,3),
    "; high vs medium: t(",
    pwcB$n1[2],")=", round(pwcB$statistic[2],3),", p=", round(pwcB$p[2],3), ", d=", round(effect_B12,3),
    "; high vs novel: t(",
    pwcB$n1[3],")=", round(pwcB$statistic[3],3),", p=", round(pwcB$p[3],3), ", d=", round(effect_B13,3),
    "; low vs medium: t(",
    pwcB$n1[4],")=", round(pwcB$statistic[4],3),", p=", round(pwcB$p[4],3), ", d=", round(effect_B24,3),
    "; low vs novel: t(",
    pwcB$n1[5],")=", round(pwcB$statistic[5],3),", p=", round(pwcB$p[5],3), ", d=", round(effect_B34,3),
    "; medium vs novel: t(",
    pwcB$n1[6],")=", round(pwcB$statistic[6],3),", p=", round(pwcB$p[6],3), ", d=", round(effect_B23,3),
    ")")
  
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""), sentence2)
  
  return(output_txt)
}

