
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_per_cond_4.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_per_cond_3.R')

#### ALL GROUPS

file_behav <- "~/MFnada/data/modelfit/thompson_percond/behaviour.xlsx";
file_param <- "~/MFnada/data/modelfit/thompson_percond/model_params.xlsx";

all_text = c(
  
  '', '', 
  
  'HIGH VALUE ', '', rm_anova_MF_per_cond_4('pickedhigh_AB_mean', 'pickedhigh_ABD_mean', 'pickedhigh_BD_mean', 'pickedhigh_AD_mean', file_behav),'','', '', 
  'LOW VALUE:', '',rm_anova_MF_per_cond_3('pickedlow_ABD_mean', 'pickedlow_AD_mean', 'pickedlow_BD_mean', file_behav),'','', '', 
  'NOVEL VALUE:', '',rm_anova_MF_per_cond_3('pickednovel_AB_mean', 'pickednovel_AD_mean', 'pickednovel_BD_mean', file_behav),'','', '', 
  
  'SGM0:','', rm_anova_MF_per_cond_4('param_sgm0_AB_mean', 'param_sgm0_ABD_mean', 'param_sgm0_AD_mean', 'param_sgm0_BD_mean', file_param),'','', '', 
  'EPSILON:', '',rm_anova_MF_per_cond_4('param_epsilon_AB_mean', 'param_epsilon_ABD_mean', 'param_epsilon_AD_mean', 'param_epsilon_BD_mean', file_param),'','', '', 
  'NOV:', '',rm_anova_MF_per_cond_4('param_eta_AB_mean', 'param_eta_ABD_mean', 'param_eta_AD_mean', 'param_eta_BD_mean', file_param)
  #'Q0:', '',rm_anova_MF_per_cond_1way('Q0')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_per_cond.txt")
writeLines(all_text, fileConn)

close(fileConn)

