
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'HIGH VALUE ', '', rm_anova_MF('high_SH', 'high_LH'),'','', '',  
  'MEDIUM VALUE:','', rm_anova_MF('med_SH', 'med_LH'),'','', '', 
  'LOW VALUE:', '',rm_anova_MF('low_SH', 'low_LH'),'','', '', 
  'NOVEL VALUE:', '',rm_anova_MF('novel_SH', 'novel_LH'),'','', '', 
  
  'SGM0:','', rm_anova_MF('sgm0_SH', 'sgm0_LH'),'','', '', 
  'EPSILON:', '',rm_anova_MF('xi_SH', 'xi_LH'),'','', '', 
  'NOV:', '',rm_anova_MF('eta_SH', 'eta_LH'),'','', '', 
  
  'CONSIST:','', rm_anova_MF('consistent_SH', 'consistent_LH'),'','', '', 
  'IG:','', rm_anova_MF('n_apples_SH', 'n_apples_LH'),'','', '', 
  'EV:','', rm_anova_MF('EV_SH', 'EV_LH'),'','', '', 
  'RT:','', rm_anova_MF('RT_SH', 'RT_LH') ,'','', '', 
  
  'SCORE: 1st SH vs 1st LH','', rm_anova_MF('first_SH', 'first_LH'),'','', '', 
  'SCORE: 1st SH vs all LH','', rm_anova_MF('first_SH', 'all_LH') 
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results.txt")
writeLines(all_text, fileConn)

close(fileConn)

