
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_perB_nodrug.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'RT:','', rm_anova_MF_perB_nodrug('RT_high_value_meanperH', 'RT_medium_value_meanperH', 'RT_novel_value_meanperH', 'RT_low_value_meanperH') 

)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_RT_perB_nodrug.txt")
writeLines(all_text, fileConn)

close(fileConn)

