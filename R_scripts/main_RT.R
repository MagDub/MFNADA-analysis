source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_RT.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'RT:','', rm_anova_MF_RT('RT_SH', 'RT_LH') ,'','', '', 
  
  'RT_heuristics:','', rm_anova_MF_RT('RT_complex', 'RT_heuristics') ,'','', '',
  
  'RT_highValue:','', rm_anova_MF_RT('RT_high_value_SH', 'RT_high_value_LH') ,'','', '',
  'RT_lowValue:','', rm_anova_MF_RT('RT_low_value_SH', 'RT_low_value_LH') ,'','', '',
  'RT_novelValue:','', rm_anova_MF_RT('RT_novel_value_SH', 'RT_novel_value_LH')

)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_RT.txt")
writeLines(all_text, fileConn)

close(fileConn)

