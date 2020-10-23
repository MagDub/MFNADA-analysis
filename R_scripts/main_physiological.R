
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_physio.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'systolic:','', rm_anova_MF_physio('initial_systolic_pressure', 'preTask_systolic_pressure', 'end_systolic_pressure'), '', '', 
  'diastolic:','', rm_anova_MF_physio('initial_diastolic_pressure', 'preTask_diastolic_pressure', 'end_diastolic_pressure'), '', '', 
  'pulse:','', rm_anova_MF_physio('initial_pulse', 'preTask_pulse', 'end_pulse')
  
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_physio.txt")
writeLines(all_text, fileConn)

close(fileConn)

