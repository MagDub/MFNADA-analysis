# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_LH <- function(x1, x2, x3, x4, x5, x6) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)
  
  x1 <- 'LH_sample1'
  x2 <- 'LH_sample2'
  x3 <- 'LH_sample3'
  x4 <- 'LH_sample4'
  x5 <- 'LH_sample5'
  x6 <- 'LH_sample6'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx", sheet = "RTLH")    
  
  # Change from wide to long format
  data_tmp <- dataMF %>%
    gather(key = "sample", value = "freq", x1, x2, x3, x4, x5, x6) %>%
    convert_as_factor(Participant, sample)
  
  # Summary statistics
  data_tmp %>%
    group_by(sample) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = sample,
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp %>%
    pairwise_t_test(freq ~ sample, paired = TRUE, p.adjust.method = "none")
  
  # sample 1 vs 2
  data_tmp12 <- dataMF %>%
    gather(key = "sample", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, sample)
  
  # sample 2 vs 3
  data_tmp23 <- dataMF %>%
    gather(key = "sample", value = "freq", x2, x3) %>%
    convert_as_factor(Participant, sample)
  
  data_tmp34 <- dataMF %>%
    gather(key = "sample", value = "freq", x3, x4) %>%
    convert_as_factor(Participant, sample)
  
  data_tmp45 <- dataMF %>%
    gather(key = "sample", value = "freq", x4, x5) %>%
    convert_as_factor(Participant, sample)
  
  data_tmp56 <- dataMF %>%
    gather(key = "sample", value = "freq", x5, x6) %>%
    convert_as_factor(Participant, sample)
  
  # Horizon effect size
  effect_s12 <-cohensD(freq ~ sample, data = data_tmp12, method = "paired")
  effect_s23 <-cohensD(freq ~ sample, data = data_tmp23, method = "paired")
  effect_s34 <-cohensD(freq ~ sample, data = data_tmp34, method = "paired")
  effect_s45 <-cohensD(freq ~ sample, data = data_tmp45, method = "paired")
  effect_s56 <-cohensD(freq ~ sample, data = data_tmp56, method = "paired")

  
  sentence1=paste(
    " (sample main effect: F(", 
    tab$DFn[4],",",tab$DFd[4],")=",round(tab$F[4],3),", p=", round(tab$p[4],3), ", pes=", round(tab$pes[4],3), 
    "; drug main effect: F(",
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3),
    "; drug-by-sample interaction: F(",
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
  

  sentence3=paste(
    "Pairwise comparisons for sample effect 
    (  sample 1 vs 2: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3), ", d=", round(effect_s12,3),
    "; sample 2 vs 3: t(",
    pwcH$n1[6],")=", round(pwcH$statistic[6],3),", p=", round(pwcH$p[6],3), ", d=", round(effect_s23,3),
    "; sample 3 vs 4: t(",
    pwcH$n1[10],")=", round(pwcH$statistic[10],3),", p=", round(pwcH$p[10],3), ", d=", round(effect_s34,3),
    "; sample 4 vs 5: t(",
    pwcH$n1[13],")=", round(pwcH$statistic[13],3),", p=", round(pwcH$p[13],3), ", d=", round(effect_s23,3),
    "; sample 5 vs 6: t(",
    pwcH$n1[15],")=", round(pwcH$statistic[15],3),", p=", round(pwcH$p[15],3), ", d=", round(effect_s34,3),
    ")")
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""), sentence3,paste(""))
  
  return(output_txt)
}

