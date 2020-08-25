
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_per_cond_4.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_per_cond_3.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'HIGH VALUE ', '', rm_anova_MF_per_cond_4('pickedhigh_AB_mean', 'pickedhigh_ABD_mean', 'pickedhigh_BD_mean', 'pickedhigh_AD_mean'),'','', '', 
  'LOW VALUE:', '',rm_anova_MF_per_cond_3('pickedlow_ABD_mean', 'pickedlow_AD_mean', 'pickedlow_BD_mean'),'','', '', 
  'NOVEL VALUE:', '',rm_anova_MF_per_cond_3('pickednovel_AB_mean', 'pickednovel_AD_mean', 'pickednovel_BD_mean')
  
  #'SGM0:','', rm_anova_MF_per_cond('sgm0_SH', 'sgm0_LH'),'','', '', 
  #'EPSILON:', '',rm_anova_MF_per_cond('xi_SH', 'xi_LH'),'','', '', 
  #'NOV:', '',rm_anova_MF_per_cond('eta_SH', 'eta_LH'),'','', '',
  #'Q0:', '',rm_anova_MF_per_cond_1way('Q0')
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_per_cond.txt")
writeLines(all_text, fileConn)

close(fileConn)

