
source('~/MFnada/MFNADA-Stats/R_scripts/fit/rm_anova_MF_ucb.R')

all_text = c(
  
  '', '', 
  
  'GAMMA:','', rm_anova_MF_ucb('gamma_short', 'gamma_long'),'','', '', 
  'TAU:','', rm_anova_MF_ucb('tau_short', 'tau_long'),'','', '',
  'EPSILON:', '',rm_anova_MF_ucb('xi_short', 'xi_long'),'','', '', 
  'NOV:', '',rm_anova_MF_ucb('eta_short', 'eta_long')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/fit/results_ucb.txt")
writeLines(all_text, fileConn)

close(fileConn)

