# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_noNA <- function(x1, x2) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  
  #x1 <- 'high_SH'
  #x2 <- 'high_LH'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506_noNA.xlsx")    
  
  # Take only subset: concatenate the ones we want
  data_tmp <- dataMF
  
  # Change from wide to long format
  data_tmp <- data_tmp %>%
    gather(key = "hor", value = "freq", x1, x2) %>%
    convert_as_factor(Participant, hor)
  
  # Display
  head(data_tmp)
  
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
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = hor,
    between = Drug,
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  sentence=paste(
    "(horizon main effect: F(", 
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

  return(sentence)
}

