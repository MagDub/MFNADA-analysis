

#### ALL GROUPS

all_text = c(
  
  '', '', 
  'Q0:','', rm_anova_MF_1way('Q0'),'','', '', 
  'CONSIST:','', rm_anova_MF_1way('consistent_both'),'','', '', 
  'IG:','', rm_anova_MF_1way('n_apples_both'),'','', '', 
  'EV:','', rm_anova_MF_1way('EV_both'),'','', '', 
  'RTmean:','', rm_anova_MF_1way('mean_RT'),'','', '', 
  'RTstd:','', rm_anova_MF_1way('mean_RT_std'),'','', '', 
  
  '1st SH:','', rm_anova_MF_1way('first_SH'),'','', '', 
  '1st LH:','', rm_anova_MF_1way('first_LH'),'','', '', 
  'all LH:','', rm_anova_MF_1way('all_LH'),'','', '', 
  
  'PANASpost_NA:','', rm_anova_MF_1way_nocov('PANASpost_NA'),'','', '', 
  'PANASpost_PA:','', rm_anova_MF_1way_nocov('PANASpost_PA'),'','', '', 
  'WASI:','', rm_anova_MF_1way_nocov('matrix_score'),'','', '', 
  'AGE:','', rm_anova_MF_1way_nocov('age')
  
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_1way.txt")
writeLines(all_text, fileConn)