# This script was provided by the Research Data Scotland workshop on synthetic data

setwd("C:/users/graab/documents/syncs/rds/workshops2")
###-------------------- repeat the first bit to get syn1---------------------
load("bike1.Rdata")
dim(bike1)
summary(bike1)
barplot(table(bike1$start_hour))
barplot(table(bike1$start_wday))
library(synthpop)
#codebook.syn(bike1)$tab
syn1 <- syn(bike1, method = "sample", seed = 5678)
#compare(syn1, bike1)
#names(syn1)
###------------------------- some plots ---------------------------------------
#png(file="latlongplot2.PNG", height =300, width=800)
par(mfrow=c(1,2))

## first original
with(bike1, plot(c(START.LAT,END.LAT),c(START.LONG,END.LONG),
                 type = "n",main="Original", xlab="Latitude", ylab="Longitude"))
with(bike1, segments(START.LAT,START.LONG,END.LAT,END.LONG))

with(bike1, plot(c(START.LAT),c(START.LONG),
                 type = "n",main="Original", xlab="Latitude", ylab="Longitude"))
with(bike1, segments(START.LAT,START.LONG,END.LAT,END.LONG))
## now synthetic
with(syn1$syn, plot(c(START.LAT,END.LAT),c(START.LONG,END.LONG),
                    type = "n",main="Synthetic", xlab="Latitude", ylab="Longitude"))
with(syn1$syn, segments(START.LAT,START.LONG,END.LAT,END.LONG))

with(syn1$syn, plot(c(START.LAT),c(START.LONG),
                    type = "n",main="Synthetic", xlab="Latitude", ylab="Longitude"))
with(syn1$syn, segments(START.LAT,START.LONG,END.LAT,END.LONG))


###------------------------- things you can do with a synds object--------------
" compare.synds   print.synds   utility (3 functions)
  disclosure (in new version)
  export data to other systems
  statistical disclosure control (sdc)
"
###------------------------first exporting -----------------------------------
"NOTE Stata and SPSS have not been tested recently so may not work"
write.syn(syn1,"syn1","csv")
utility.tables(syn1,bike1)  ## on plot S_pMSE should be below 10. Is it here?

syn1.sdc <- sdc(syn1,bike1, label = "Not real data")
summary(syn1.sdc)
head(syn1.sdc$syn)

syn1.sdc2 <- sdc(syn1,bike1, label = "Not real data",rm.replicated.uniques = TRUE)

###-------------------------- check if duration should be top or bottom coded--------------

head(table(bike1$dur_minutes))
tail(table(bike1$dur_minutes))
tail(table(bike1$dur_minutes/60/24), n=20) ## to get it in days
tail(table(round(bike1$dur_minutes/60/24)), n=20) ## rounding to whole days
## from synthetic
tail(table(round(syn1$syn$dur_minutes/60/24)), n=20) ## similar
###-----------suggests topcoding above 7------------------------
syn1.sdc3 <- sdc(syn1,bike1, label = "Not real data",rm.replicated.uniques = TRUE,
                 recode.vars = "dur_minutes", bottom.top.coding = c(NA,7))
### oops  this looks wrong try againn
syn1.sdc3 <- sdc(syn1,bike1, label = "Not real data",rm.replicated.uniques = TRUE,
                 recode.vars = "dur_minutes", bottom.top.coding = c(NA,7*60*24))

tail(table(round(syn1.sdc3$syn$dur_minutes/60/24)), n=20) ## similar
### that looks better
summary(syn1.sdc3)
###--------------------- now smoothing---------------------------------
### drop the topcoding
syn1.sdc4 <- sdc(syn1,bike1, label = "Not real data",smooth.vars ="dur_minutes")

tail(table(bike1$dur_minutes/60/24))
tail(table(syn1.sdc4$syn$dur_minutes/60/24))

### this could be a better alyernative to topcoding here
###--------------------------------------------------------------------

