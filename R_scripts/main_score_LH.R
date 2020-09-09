
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_LH_score.R')
source('~/MFnada/MFNADA-Stats/R_scripts/fct_analysis_2way_score.R')

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'score:','', rm_anova_MF_LH_score('score_sample1', 'score_sample2', 'score_sample3', 'score_sample4', 'score_sample5', 'score_sample6'),'','', '', 
  
  'score: sample 1 vs 2','', rm_anova_MF_score('score_sample1', 'score_sample2'),'','', '', 
  'score: sample 2 vs 3','', rm_anova_MF_score('score_sample2', 'score_sample3'),'','', '', 
  'score: sample 3 vs 4','', rm_anova_MF_score('score_sample3', 'score_sample4'),'','', '', 
  'score: sample 4 vs 5','', rm_anova_MF_score('score_sample4', 'score_sample5'),'','', '',
  'score: sample 5 vs 4','', rm_anova_MF_score('score_sample5', 'score_sample6')
  
)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_score_LH.txt")
writeLines(all_text, fileConn)

close(fileConn)

