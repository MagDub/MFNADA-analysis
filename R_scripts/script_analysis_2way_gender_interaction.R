# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/


  library(car)
  library(lsr)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  
  x <- 'sgm0_mean'

  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")    
  
  # Take only subset: concatenate the ones we want
  data_tmp <- subset(dataMF , select=c("Participant", x, "isMale", "Drug", "DrugCode", "matrix_score", "PANASpost_NA"))

  # Display
  head(data_tmp)
  
  # Summary statistics
  data_tmp %>%
    group_by(isMale, Drug) %>%
    get_summary_stats(x, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = x, wid = Participant,
    between = c(Drug, isMale),
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp %>%
    group_by(Drug) %>%
    pairwise_t_test(sgm0_mean ~ isMale, paired = FALSE, pool.sd = FALSE, p.adjust.method = "none") 
  
  # Split by drug group
  data_tmp0 <- data_tmp[data_tmp$DrugCode == 0, ]
  data_tmp1 <- data_tmp[data_tmp$DrugCode == 1, ]
  data_tmp2 <- data_tmp[data_tmp$DrugCode == 2, ]
  
  # Effect size
  effect_pwcH0 = cohensD(sgm0_mean ~ isMale, data = data_tmp0)
  effect_pwcH1 = cohensD(sgm0_mean ~ isMale, data = data_tmp1)
  effect_pwcH2 = cohensD(sgm0_mean ~ isMale, data = data_tmp2)

  
  
  sentence=paste(
    "(horizon main effect: F(", 
    tab$DFn[5],",",tab$DFd[5],")=",round(tab$F[5],3),", p=", round(tab$p[5],3), ", pes=", round(tab$pes[5],3), 
    "; drug main effect: F(",
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3),
    "; gender main effect: F(",
    tab$DFn[4],",",tab$DFd[4],")=",round(tab$F[4],3),", p=", round(tab$p[4],3), ", pes=", round(tab$pes[4],3),
    "; drug-by-gender interaction: F(",
    tab$DFn[6],",",tab$DFd[6],")=",round(tab$F[6],3),", p=", round(tab$p[6],3), ", pes=", round(tab$pes[6],3),
    "; drug-by-horizon interaction: F(",
    tab$DFn[9],",",tab$DFd[9],")=",round(tab$F[9],3),", p=", round(tab$p[9],3), ", pes=", round(tab$pes[9],3),
    "; horizon-by-gender interaction: F(",
    tab$DFn[10],",",tab$DFd[10],")=",round(tab$F[10],3),", p=", round(tab$p[10],3), ", pes=", round(tab$pes[10],3),
    ")")
  
  sentence2=paste(
    "Pairwise comparisons for gender effect (placebo: t(",
    pwcH$n1[2]+pwcH$n2[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3), ", d=", round(effect_pwcH0,3),
    "; noradrenaline: t(",
    pwcH$n1[3]+pwcH$n2[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3), ", d=", round(effect_pwcH2,3),
    "; dopamine: t(",
    pwcH$n1[1]+pwcH$n2[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3), ", d=", round(effect_pwcH1,3),
    ")")



