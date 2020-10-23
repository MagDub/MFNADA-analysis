# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_physio <- function(x1, x2, x3) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm.xlsx")  
  
  # Remove participant 506
  dataMF_ <- dataMF[-c(6, 19), c('Participant', 'Drug', 'DrugCode', x1, x2, x3) ]
  
  # Change from wide to long format
  data_tmp <- dataMF_ %>%
    gather(key = "time", value = "measure", x1, x2, x3) %>%
    convert_as_factor(Participant, time)
  
  # Summary statistics
  data_tmp %>%
    group_by(Drug) %>%
    get_summary_stats(measure, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = measure, wid = Participant,
    within = time,
    between = Drug,
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp %>%
    pairwise_t_test(measure ~ time, paired = TRUE, p.adjust.method = "none")
  
  # sample 1 vs 2
  data_tmp12 <- dataMF %>%
    gather(key = "sample", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, sample)
  
  # sample 2 vs 3
  data_tmp23 <- dataMF %>%
    gather(key = "sample", value = "freq", x2, x3) %>%
    convert_as_factor(Participant, sample)
  
  # sample 1 vs 3
  data_tmp13 <- dataMF %>%
    gather(key = "sample", value = "freq", x1, x3) %>%
    convert_as_factor(Participant, sample)
  
  # Horizon effect size
  effect_s12 <-cohensD(freq ~ sample, data = data_tmp12, method = "paired")
  effect_s23 <-cohensD(freq ~ sample, data = data_tmp23, method = "paired")
  effect_s13 <-cohensD(freq ~ sample, data = data_tmp23, method = "paired")

  sentence1=paste(
    " (Drug main effect: F(", 
    tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3), 
    "; Time main effect: F(",
    tab$DFn[2],",",tab$DFd[2],")=",round(tab$F[2],3),", p=", round(tab$p[2],3), ", pes=", round(tab$pes[2],3),
    "; Drug-by-time interaction: F(",
    tab$DFn[3],",",tab$DFd[3],") =",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3),
    ")") 
  
  sentence3=paste(
    "Pairwise comparisons for time effect 
    (  time 3 vs 1: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3), ", d=", round(effect_s13,3),
    "; time 3 vs 2: t(",
    pwcH$n1[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3), ", d=", round(effect_s23,3),
    "; time 1 vs 2: t(",
    pwcH$n1[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3), ", d=", round(effect_s12,3),
    ")")
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""), sentence3,paste(""))
  
  return(output_txt)
}

