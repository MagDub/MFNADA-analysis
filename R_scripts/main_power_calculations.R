# https://rdrr.io/cran/WebPower/man/wp.rmanova.html
# https://webpower.psychstat.org/models/means05/

library(WebPower)
library(readxl)
library(sjstats)
library(car)
library(pwr)

# Other
x1 <- 'low_SH'
x2 <- 'low_LH'

# Take only subset: concatenate the ones we want
dataMFdev <- read_excel("~/GoogleDrive/UCL/MF/analysis/stats/data_for_R/thomp_3_params_like_param_recovery_Q0norm_no506.xlsx")   

data_tmp <- subset(dataMFdev , select=c("Participant", x1, x2, "Drug", "matrix_score", "PANASpost_NA"))

# Change from wide to long format
data_tmp <- data_tmp %>%
  gather(key = "hor", value = "freq", x1, x2) %>%
  convert_as_factor(Participant, hor)

# Anova computation
res <- anova_test(
  data = data_tmp, dv = freq, wid = Participant,
  within = hor,
  between = Drug,
  covariate = c(matrix_score, PANASpost_NA),
  effect.size = "ges"
)

tab<-get_anova_table(res)

# http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/effectSize
Cohens_f = sqrt(tab$ges[3] / (1 - tab$ges[3]))

# To calculate the statistical power for repeated-measures ANOVA:
# n = sample size, ng = number of groups, nm = number of measurements, f = effect size, nscor = nonsphericity correction coefficient
# Type of analysis: 0 is between-effect; 1 is within-effect; 2 is interaction effect
finNow<-wp.rmanova(n=59, ng=3, nm=2, nscor=1, f=Cohens_f, type=1)

# It is generally accepted that power should be . 8 or greater; that is, you should have 
# an 80% or greater chance of finding a statistically significant difference when there is one.


