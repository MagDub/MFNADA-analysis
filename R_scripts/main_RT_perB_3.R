

#### ALL GROUPS

all_text = c(
  
  '', '', 
  
  'RT:','', rm_anova_MF_perB3('RT_high_value_meanperH', 'RT_novel_value_meanperH', 'RT_low_value_meanperH') 

)

fileConn<-file("~/MFnada/MFNADA-Stats/txt_res/results_RT_perB3.txt")
writeLines(all_text, fileConn)

close(fileConn)

