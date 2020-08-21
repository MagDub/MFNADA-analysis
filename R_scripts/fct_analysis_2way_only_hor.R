# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_only_hor <- function(x1, x2) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  
  # x1 <- 'high_SH'
  # x2 <- 'high_LH'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm.xlsx")  
  
  # Remove participant 506
  dataMF <- dataMF[-c(6), ]
  
  # Change from wide to long format
  data_tmp <- dataMF %>%
    gather(key = "hor", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, hor)
  
  # Summary statistics
  sum_stats <- data_tmp %>%
    group_by(hor) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = hor,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Pairwise comparisons
  pwcH <- data_tmp %>%
    group_by(Drug) %>%
    pairwise_t_test(freq ~ hor, paired = TRUE, p.adjust.method = "none")
  
  
  #es <- cohens_d(data=data_tmp, comparisons = list(c("placebo","amisulpride"), freq ~ hor, paired = TRUE)
  
  sentence1=paste(
    " SH mean: ",  sum_stats$mean[2], "(", sum_stats$sd[2], "), LH mean: ",  sum_stats$mean[1], "(", sum_stats$sd[1], ") ;",
    " (horizon main effect: F(", 
    tab$DFn[3],",",tab$DFd[3],")=",round(tab$F[3],3),", p=", round(tab$p[3],3), ", pes=", round(tab$pes[3],3), 
    "; WASI main effect: F(",
    tab$DFn[1],",",tab$DFd[1],")=",round(tab$F[1],3),", p=", round(tab$p[1],3), ", pes=", round(tab$pes[1],3),
    "; WASI-by-horizon interaction: F(",
    tab$DFn[4],",",tab$DFd[4],") =",round(tab$F[4],3),", p=", round(tab$p[4],3), ", pes=", round(tab$pes[4],3),
    "; PANAS_NA main effect: F(",
    tab$DFn[2],",",tab$DFd[2],") =",round(tab$F[2],3),", p=", round(tab$p[2],3), ", pes=", round(tab$pes[2],3),
    "; PANAS_NA-by-horizon interaction: F(",
    tab$DFn[5],",",tab$DFd[5],") =",round(tab$F[5],3),", p=", round(tab$p[5],3), ", pes=", round(tab$pes[5],3),
    ")") 
  
  sentence2=paste(
    "Pairwise comparisons for horizon effect (placebo: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3),
    "; noradrenaline: t(",
    pwcH$n1[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3),
    "; dopamine: t(",
    pwcH$n1[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3),
    ")")
  
  mid=paste("-------------------------------------------------------")

  output_txt = c(sentence1,paste(""), mid, paste(""),sentence2)
  
  return(output_txt)
}

