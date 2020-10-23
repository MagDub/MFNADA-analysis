# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_perB3_nodrug <- function(x1, x2, x3) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  library(lsr)
  
  x1 <- 'RT_high_value_meanperH'
  x2 <- 'RT_low_value_meanperH'
  x3 <- 'RT_novel_value_meanperH'

  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")   
  
  dataMF_ <- dataMF[, c('Participant', x1, x2, x3, 'matrix_score', 'PANASpost_NA') ]
  
  # Change from wide to long format
  data_tmp <- dataMF_ %>%
    gather(key = "bandit", value = "freq", x1, x2, x3) %>%
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

  
  sentence1=paste(
    " (bandit main effect: F(", 
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3), 
    ")") 
  
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""))
  
  return(output_txt)
}

