
source('~/MFnada/MFNADA-Stats/R_scripts/fit/rm_anova_MF_hyb.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fit/rm_anova_MF_hyb_pulse.R')

all_text = c(
  
  '', '', 
  
  'SGM0:','', rm_anova_MF_hyb('sgm0_short', 'sgm0_long'),'','', '', 
  'GAMMA:','', rm_anova_MF_hyb('gamma_short', 'gamma_long'),'','', '', 
  'TAU:','', rm_anova_MF_hyb('tau_short', 'tau_long'),'','', '',
  'EPSILON:', '',rm_anova_MF_hyb('xi_short', 'xi_long'),'','', '', 
  'NOV:', '',rm_anova_MF_hyb('eta_short', 'eta_long'),'','', '', 
  
  '', '', 
  
  'with pulse as covariate', 
  
  '', '', 
  
  'GAMMA:','', rm_anova_MF_hyb_pulse('gamma_short', 'gamma_long'),'','', '', 
  'TAU:','', rm_anova_MF_hyb_pulse('tau_short', 'tau_long'),'','', '',
  'EPSILON:', '',rm_anova_MF_hyb_pulse('xi_short', 'xi_long'),'','', '', 
  'NOV:', '',rm_anova_MF_hyb_pulse('eta_short', 'eta_long')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/fit/results_hyb.txt")
writeLines(all_text, fileConn)

close(fileConn)

