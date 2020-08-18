
source('~/GoogleDrive/UCL/MF/analysis/stats/R_scripts/fct_analysis_2way.R')
source('~/GoogleDrive/UCL/MF/analysis/stats/R_scripts/fct_analysis_1way.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'Q0:','', rm_anova_MF_1way('mod8_UCB_Q0'),'','', '', 
  'GAMMA:','', rm_anova_MF('mod8_UCB_gamma_SH', 'mod8_UCB_gamma_LH'),'','', '', 
  'TAU:','', rm_anova_MF('mod8_UCB_tau_SH', 'mod8_UCB_tau_LH'),'','', '', 
  'ETA:','', rm_anova_MF('mod8_UCB_eta_SH', 'mod8_UCB_eta_LH'),'','', '', 
  'XI:','', rm_anova_MF('mod8_UCB_xi_SH', 'mod8_UCB_xi_LH')
  
)

fileConn<-file("~/GoogleDrive/UCL/MF/analysis/stats/txt_res/results_mod8.txt")
writeLines(all_text, fileConn)
close(fileConn)


