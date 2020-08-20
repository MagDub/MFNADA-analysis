
source('~/MFnada/MFNADA-Stats/R_scripts/fit/rm_anova_MF_thomp.R')

all_text = c(
  
  '', '', 
  
  'SGM0:','', rm_anova_MF_thomp('sgm0_short', 'sgm0_long'),'','', '', 
  'EPSILON:', '',rm_anova_MF_thomp('xi_short', 'xi_long'),'','', '', 
  'NOV:', '',rm_anova_MF_thomp('eta_short', 'eta_long')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/fit/results_thompson.txt")
writeLines(all_text, fileConn)

close(fileConn)

