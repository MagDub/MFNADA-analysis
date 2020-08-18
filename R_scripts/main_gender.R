
source('~/GoogleDrive/UCL/MF/analysis/stats/R_scripts/fct_analysis_2way_gender.R')


#### ALL GROUPS

all_text = c(
  
  'HIGH VALUE ', rm_anova_MF_gender('high_SH', 'high_LH'), 
  'MEDIUM VALUE:', rm_anova_MF_gender('med_SH', 'med_LH'),
  'LOW VALUE:', rm_anova_MF_gender('low_SH', 'low_LH'),
  'NOVEL VALUE:', rm_anova_MF_gender('novel_SH', 'novel_LH'),
  
  'SGM0:', rm_anova_MF_gender('sgm0_SH', 'sgm0_LH'),
  'EPSILON:', rm_anova_MF_gender('xi_SH', 'xi_LH'),
  'NOV:', rm_anova_MF_gender('eta_SH', 'eta_LH'),
  
  'CONSIST:', rm_anova_MF_gender('consistent_SH', 'consistent_LH'),
  'IG:', rm_anova_MF_gender('n_apples_SH', 'n_apples_LH'),
  'EV:', rm_anova_MF_gender('EV_SH', 'EV_LH'),
  'RT:', rm_anova_MF_gender('RT_SH', 'RT_LH')
)

fileConn<-file("~/GoogleDrive/UCL/MF/analysis/stats/txt_res/results_gender.txt")
writeLines(all_text, fileConn)
close(fileConn)