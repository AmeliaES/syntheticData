# This script was provided by the Research Data Scotland workshop on synthetic data

setwd("C:/users/graab/documents/syncs/rds/workshops2")
load("bike1.Rdata")
dim(bike1)
summary(bike1)
barplot(table(bike1$start_hour))
barplot(table(bike1$start_wday))
library(synthpop)
codebook.syn(bike1)$tab
syn1 <- syn(bike1, method = "sample", seed = 5678)
summary(syn1)
compare(syn1, bike1)

names(syn1)

