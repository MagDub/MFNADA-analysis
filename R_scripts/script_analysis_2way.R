# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix) # pairwise t-tests
  library(readxl)

  
  x1 <- 'high_SH'
  x2 <- 'high_LH'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")    
  
  # Take only subset: concatenate the ones we want
  data_tmp <- dataMF
  
  # Change from wide to long format
  data_tmp <- data_tmp %>%
    gather(key = "hor", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, hor)
  
  # Display
  #head(data_tmp)
  
  # Summary statistics
  data_tmp %>%
    group_by(hor, Drug) %>%
    get_summary_stats(freq, type = "mean_sd")
  
  # Visualisation
  bxp <- ggboxplot(
    data_tmp, x = "hor", y = "freq",
   color="Drug", palette = "jco"
    )
  bxp
  
  # Anova computation
  two.way <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = hor,
    between = Drug,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(two.way)

  # Pairwise comparisons
  pwcH <- data_tmp %>%
    group_by(Drug) %>%
    pairwise_t_test(freq ~ hor, paired = TRUE, p.adjust.method = "none")
  
  # Pairwise comparisons
  pwcD <- data_tmp %>%
    pairwise_t_test(freq ~ Drug, paired = FALSE, pool.sd = FALSE, p.adjust.method = "none")
  
  # Pairwise comparisons
  pwcHD <- data_tmp %>%
    group_by(hor) %>%
    pairwise_t_test(freq ~ Drug, paired = FALSE, pool.sd = FALSE, p.adjust.method = "none")
  
    
  #es <- cohens_d(data=data_tmp, comparisons = list(c("placebo","amisulpride"), freq ~ hor, paired = TRUE)
  
  sentence=cat(
    "\n (horizon main effect: F(", 
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
    ") \n-------------------------------------------------------\n",
    "Pairwise comparisons for horizon effect (placebo: t(",
    pwcH$n1[1],")=", round(pwcH$statistic[1],3),", p=", round(pwcH$p[1],3),
    "; noradrenaline: t(",
    pwcH$n1[3],")=", round(pwcH$statistic[3],3),", p=", round(pwcH$p[3],3),
    "; dopamine: t(",
    pwcH$n1[2],")=", round(pwcH$statistic[2],3),", p=", round(pwcH$p[2],3),
    ") \n-------------------------------------------------------\n",
    "Pairwise comparisons for drug effect (placebo vs noradrenaline: t(",
    pwcD$n1[3],")=", round(pwcD$statistic[3],3),", p=", round(pwcD$p[3],3),
    "; dopamine vs placebo: t(",
    pwcD$n1[1],")=", round(pwcD$statistic[1],3),", p=", round(pwcD$p[1],3),
    "; dopamine vs noradrenaline: t(",
    pwcD$n1[2],")=", round(pwcD$statistic[2],3),", p=", round(pwcD$p[2],3),
    ") \n-------------------------------------------------------\n",
    "Pairwise comparisons for horizon x drug effect: ", 
    "\n short horizon: ", 
    "(placebo vs noradrenaline: t(",
    pwcHD$n1[6],")=", round(pwcHD$statistic[6],3),", p=", round(pwcHD$p[6],3),
    "; dopamine vs placebo: t(",
    pwcHD$n1[4],")=", round(pwcHD$statistic[4],3),", p=", round(pwcHD$p[4],3),
    "; dopamine vs noradrenaline: t(",
    pwcHD$n1[5],")=", round(pwcHD$statistic[5],3),", p=", round(pwcHD$p[5],3),
    "\n long horizon: ", 
    "(placebo vs noradrenaline: t(",
    pwcHD$n1[3],")=", round(pwcHD$statistic[3],3),", p=", round(pwcHD$p[3],3),
    "; dopamine vs placebo: t(",
    pwcHD$n1[1],")=", round(pwcHD$statistic[1],3),", p=", round(pwcHD$p[1],3),
    "; dopamine vs noradrenaline: t(",
    pwcHD$n1[2],")=", round(pwcHD$statistic[2],3),", p=", round(pwcHD$p[2],3),
    ")) \n ")

