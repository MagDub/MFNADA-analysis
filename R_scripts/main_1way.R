
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_1way.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_1way_nocov.R')

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
  'score:','', rm_anova_MF_1way('score_average'),'','', '', 
  
  'PANASpost_NA:','', rm_anova_MF_1way_nocov('PANASpost_NA'),'','', '', 
  'PANASpost_PA:','', rm_anova_MF_1way_nocov('PANASpost_PA'),'','', '', 
  'WASI:','', rm_anova_MF_1way_nocov('matrix_score'),'','', '', 
  'AGE:','', rm_anova_MF_1way_nocov('age'),'','', '', 
  
  'INITIAL SYSTOLIC:','', rm_anova_MF_1way_nocov('initial_systolic_pressure'),'','', '', 
  'INITIAL DIASTOLIC:','', rm_anova_MF_1way_nocov('initial_diastolic_pressure'),'','', '', 
  'INITIAL PULSE:','', rm_anova_MF_1way_nocov('initial_pulse'),'','', '', 
  
  'PRE TASK SYSTOLIC:','', rm_anova_MF_1way_nocov('preTask_systolic_pressure'),'','', '', 
  'PRE TASK DIASTOLIC:','', rm_anova_MF_1way_nocov('preTask_diastolic_pressure'),'','', '', 
  'PRE TASK PULSE:','', rm_anova_MF_1way_nocov('preTask_pulse'),'','', '',
  
  'END SYSTOLIC:','', rm_anova_MF_1way_nocov('end_systolic_pressure'),'','', '', 
  'END DIASTOLIC:','', rm_anova_MF_1way_nocov('end_diastolic_pressure'),'','', '', 
  'END PULSE:','', rm_anova_MF_1way_nocov('end_pulse')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_1way.txt")
writeLines(all_text, fileConn)