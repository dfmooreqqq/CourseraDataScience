##### Load previously generated ngramlookup table and do the predicting

#load some libraries
library(plyr)
library(reshape2)
library(tm) #Text mining
library(SnowballC) #Provides wordStem()
library(RColorBrewer) #color palette
library(ggplot2)
library(magrittr)
library(Rgraphviz) #from bioconductor 0 install via - source("http://bioconductor.org/biocLite.R");biocLite("Rgraphviz")
library(wordcloud)
library(RWeka) # for doing the bigrams



setwd("C:\\Users\\damoore\\Documents\\GitHub\\DataScienceCapstone")
setwd("C:\\Users\\Daniel\\Documents\\GitHub\\DataScienceCapstone")


file = "ngramlookuptable_20141105.csv"

ngramlookuptable<-read.csv(file)
ngramlookuptable$X<-as.character(ngramlookuptable$X)
ngramlookuptable$endstate<-as.character(ngramlookuptable$endstate)
ngramlookuptable$startstate<-as.character(ngramlookuptable$startstate)


library(data.table)
unknownmax<-ddply(ngramlookuptable, .(endstate, NgramSize), nrow)
unknownmax<-lapply(split(unknownmax, unknownmax$NgramSize), function(x) {x[which.max(x$V1), c(1)]})
unknownmax<-as.data.frame(do.call(rbind, unknownmax))
unknownmax$ngramsize<-row.names(unknownmax)

##### Okay, here's where you can get your most recommended suggestion
inputstring<-"a case of"
inputstring<-removePunctuation(inputstring))
inputstring<-tolower(inputstring)
inputstring<-removeNumbers(inputstring)
inputstring<-stripWhitespace(inputstring)
#inputstring<-"for the fghutioj"

outputstring<-subset(ngramlookuptable, startstate==inputstring)$endstate
splitstr<-strsplit(inputstring, " ")[[1]]
lengthofinput<-length(splitstr)
outputstring<-ifelse(
    #If output string is in the table
    inputstring %in% ngramlookuptable$startstate,
    #then return corresponding endstate
    subset(ngramlookuptable, startstate==inputstring)$endstate, 
    #Else
    #if length of input string == 3
    ifelse(
        #if length of input string == 3
        lengthofinput==3,
        ifelse(
            paste(splitstr[2], splitstr[3], sep=" ") %in% ngramlookuptable$startstate,
            subset(ngramlookuptable, startstate==paste(splitstr[2], splitstr[3], sep=" "))$endstate,
            subset(ngramlookuptable, startstate==splitstr[3])$endstate
        )
        ,
        ifelse(
            lengthofinput==2,
            subset(ngramlookuptable, startstate==splitstr[2])$endstate
        )
    )
)

ifelse(
    is.na(outputstring),
    outputstring<-as.character(unknownmax[unknownmax$ngramsize==lengthofinput+1,]$V1[[1]]), #### need to change this to most common 4th, 3rd, or 2nd word
    outputstring<-outputstring
)
