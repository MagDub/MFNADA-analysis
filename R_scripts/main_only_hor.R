
source('~/GoogleDrive/UCL/MF/analysis/stats/R_scripts/fct_analysis_2way_only_hor.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'HIGH VALUE ', '', rm_anova_MF_only_hor('high_SH', 'high_LH'),'','', '', 
  'LOW VALUE ', '', rm_anova_MF_only_hor('low_SH', 'low_LH'),'','', '', 
  'NOVEL ', '', rm_anova_MF_only_hor('novel_SH', 'novel_LH'),'','', '', 
  
  'IG:','', rm_anova_MF_only_hor('n_apples_SH', 'n_apples_LH'),'','', '', 
  'EV:','', rm_anova_MF_only_hor('EV_SH', 'EV_LH'),'','', '', 
  'RT:','', rm_anova_MF_only_hor('RT_SH', 'RT_LH') ,'','', '', 
  
  'SCORE: 1st SH vs 1st LH','', rm_anova_MF_only_hor('first_SH', 'first_LH'),'','', '', 
  'SCORE: 1st SH vs all LH','', rm_anova_MF_only_hor('first_SH', 'all_LH') 
)

fileConn<-file("~/GoogleDrive/UCL/MF/analysis/stats/txt_res/results_onlyhor.txt")
writeLines(all_text, fileConn)
close(fileConn)
