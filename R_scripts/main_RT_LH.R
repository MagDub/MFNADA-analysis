
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_LH.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_RT.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'RT:','', rm_anova_MF_LH('LH_sample1', 'LH_sample2', 'LH_sample3', 'LH_sample4', 'LH_sample5', 'LH_sample6'),'','', '', 
  
  'RT: sample 1 vs 2','', rm_anova_MF_RT('LH_sample1', 'LH_sample2'),'','', '', 
  'RT: sample 2 vs 3','', rm_anova_MF_RT('LH_sample2', 'LH_sample3'),'','', '', 
  'RT: sample 3 vs 4','', rm_anova_MF_RT('LH_sample3', 'LH_sample4'),'','', '', 
  'RT: sample 4 vs 5','', rm_anova_MF_RT('LH_sample4', 'LH_sample5'),'','', '',
  'RT: sample 5 vs 4','', rm_anova_MF_RT('LH_sample5', 'LH_sample6')
  
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_RT_LH.txt")
writeLines(all_text, fileConn)

close(fileConn)

