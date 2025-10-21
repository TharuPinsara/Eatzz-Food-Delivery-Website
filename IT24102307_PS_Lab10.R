setwd("D:\\it24102307\\Lab10")
getwd()

#Exercise

#i.
observed<-c(120,95,85,100)
prob<-c(.25,.25,.25,.25)
chisq.test(x=observed,p=prob)

#ii.
file_path <-  "http://www.sthda.com/sthda/RDoc/data/housetasks.txt" 
housetasks <- read.delim(file_path, row.names =  1)
housetasks

chisq <- chisq.test(housetasks)
chisq

#iii.
#consider 5% level of significance for the test
#Rejection region:if the p value for the test id less than 0.05
#reject the null hypothesis at the 5% level of significant
#p level for the level is 0.08966
#Conclusion:since the p value is (0.08966) is greater than 0.05 ,do not reject the null hypothesis at 5%
#level pf significance .therefore  we can conclude that of customers choosing 4 snack types will be same which is 0.25


  