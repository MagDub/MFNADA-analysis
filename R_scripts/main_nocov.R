
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_nocov.R')


#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'HIGH VALUE ', '', rm_anova_MF_nocov('high_SH', 'high_LH'),'','', '',  
  'MEDIUM VALUE:','', rm_anova_MF_nocov('med_SH', 'med_LH'),'','', '', 
  'LOW VALUE:', '',rm_anova_MF_nocov('low_SH', 'low_LH'),'','', '', 
  'NOVEL VALUE:', '',rm_anova_MF_nocov('novel_SH', 'novel_LH'),'','', '', 
  
  'SGM0:','', rm_anova_MF_nocov('sgm0_SH', 'sgm0_LH'),'','', '', 
  'EPSILON:', '',rm_anova_MF_nocov('xi_SH', 'xi_LH'),'','', '', 
  'NOV:', '',rm_anova_MF_nocov('eta_SH', 'eta_LH'),'','', '', 
  
  'CONSIST:','', rm_anova_MF_nocov('consistent_SH', 'consistent_LH'),'','', '', 
  'IG:','', rm_anova_MF_nocov('n_apples_SH', 'n_apples_LH'),'','', '', 
  'EV:','', rm_anova_MF_nocov('EV_SH', 'EV_LH'),'','', '', 
  'RT:','', rm_anova_MF_nocov('RT_SH', 'RT_LH') ,'','', '', 
  
  'SCORE: 1st SH vs 1st LH','', rm_anova_MF_nocov('first_SH', 'first_LH'),'','', '', 
  'SCORE: 1st SH vs all LH','', rm_anova_MF_nocov('first_SH', 'all_LH') 
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_nocov.txt")
writeLines(all_text, fileConn)
close(fileConn)