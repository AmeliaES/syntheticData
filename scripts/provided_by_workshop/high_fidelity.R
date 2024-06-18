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
system.time(syn1 <- syn(bike1, method = "sample", seed = 5678)) ## under 2seconds
#compare(syn1, bike1)
#names(syn1)
###------------------- now try some high fidelity methods-------------------
system.time(syn1.cart <-  syn(bike1, seed = 5678)) ### uses default method "cart"
### took 600 secs on this University machine 288 on my home one
###------------------------- some plots ---------------------------------------
#png(file="latlongplot2.PNG", height =300, width=800)
par(mfrow=c(1,3))

with(bike1, plot(c(START.LAT),c(START.LONG),
                 type = "n",main="Low fidelity", xlab="Latitude", ylab="Longitude"))
with(syn1$syn, segments(START.LAT,START.LONG,END.LAT,END.LONG))
## now Original
with(bike1, plot(c(START.LAT),c(START.LONG),
                 type = "n",main="?Original or High fidelity", xlab="Latitude", ylab="Longitude"))
with(bike1, segments(START.LAT,START.LONG,END.LAT,END.LONG))
## now High fidelity
with(bike1, plot(c(START.LAT),c(START.LONG),
                 type = "n",main="?Original or High fidelity", xlab="Latitude", ylab="Longitude"))
with(syn1.cart$syn, segments(START.LAT,START.LONG,END.LAT,END.LONG))

###------------------------- now try parametric -------------

system.time(syn1.para <-  syn(bike1, method = "parametric", visit.sequence = c(7:10,1:6), seed = 5678))
## moved factors with lots of levels to end of visit.sequence
## but not enough as my effort ran out of time


