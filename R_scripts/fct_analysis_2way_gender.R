# source and then on terminal ex: 
# s<-rm_anova_MF('freq_D_picked_shortH', 'freq_D_picked_longH')

# From example: https://www.datanovia.com/en/lessons/repeated-measures-anova-in-r/

rm_anova_MF_gender <- function(x1, x2) {

  library(car)
  library(tidyverse)
  library(ggpubr)
  library(rstatix)
  library(readxl)
  
  #x1 <- 'novel_SH'
  #x2 <- 'novel_LH'
  
  dataMF <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")    
  
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
  # bxp <- ggboxplot(
  #  data_tmp, x = "hor", y = "freq",
  #  color="Drug", palette = "jco"
  #  )
  # bxp
  
  # Anova computation
  res.aov <- anova_test(
    data = data_tmp, dv = freq, wid = Participant,
    within = hor,
    between = c(Drug, isMale),
    covariate = c(matrix_score, PANASpost_NA),
    effect.size = "pes"
  )
  
  tab<-get_anova_table(res.aov)
  
  # Split by group
  data_tmp0 <- data_tmp[data_tmp$DrugCode == 0, ]
  data_tmp1 <- data_tmp[data_tmp$DrugCode == 1, ]
  data_tmp2 <- data_tmp[data_tmp$DrugCode == 2, ]
  
  # Split by pairs
  data_tmp01 <- data_tmp[data_tmp$DrugCode == 0 | data_tmp$DrugCode == 1, ]
  data_tmp12 <- data_tmp[data_tmp$DrugCode == 1 | data_tmp$DrugCode == 2, ]
  data_tmp02 <- data_tmp[data_tmp$DrugCode == 0 | data_tmp$DrugCode == 2, ]
  
  # Age effect size
  effect_pwcD01 <-cohensD(freq ~ DrugCode, data = data_tmp01)
  effect_pwcD12 <-cohensD(freq ~ DrugCode, data = data_tmp12)
  effect_pwcD02 <-cohensD(freq ~ DrugCode, data = data_tmp02)
  
  # Horizon effect size
  effect_pwcH0 <-cohensD(freq ~ hor, data = data_tmp0, method = "paired")
  effect_pwcH1 <-cohensD(freq ~ hor, data = data_tmp1, method = "paired")
  effect_pwcH2 <-cohensD(freq ~ hor, data = data_tmp2, method = "paired")
  
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

   return(sentence)
 }

