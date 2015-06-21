#load some libraries
library(plyr)
library(reshape2)
library(tm) #Text mining
# library(SnowballC) #Provides wordStem()
# library(RColorBrewer) #color palette
# library(ggplot2)
# library(magrittr)
# library(Rgraphviz) #from bioconductor 0 install via - source("http://bioconductor.org/biocLite.R");biocLite("Rgraphviz")
# library(wordcloud)
# library(RWeka) # for doing the bigrams

# Let's load the full season csv from the github depository
### Need to find a host for the data
#file = "http://www.danielfmoore.com/stats/ngramlookuptable_20141113.csv"
#file = "www/ngramlookuptable_20141113.csv"
#filenostopwords = "www/ngramlookupuptablenostopwords_20141113.csv"

#ngramlookuptable<-read.csv(file)
load("www/nglookup.rdata")
ngramlookuptable$X<-as.character(ngramlookuptable$X)
ngramlookuptable$endstate<-as.character(ngramlookuptable$endstate)
ngramlookuptable$startstate<-as.character(ngramlookuptable$startstate)

library(data.table)
unknownmax<-ddply(ngramlookuptable, .(endstate, NgramSize), nrow)
unknownmax<-lapply(split(unknownmax, unknownmax$NgramSize), function(x) {x[which.max(x$V1), c(1)]})
unknownmax<-as.data.frame(do.call(rbind, unknownmax))
unknownmax$ngramsize<-row.names(unknownmax)


# ngramlookuptablenostopwords<-read.csv(filenostopwords)
# ngramlookuptablenostopwords$X<-as.character(ngramlookuptablenostopwords$X)
# ngramlookuptablenostopwords$endstate<-as.character(ngramlookuptablenostopwords$endstate)
# ngramlookuptablenostopwords$startstate<-as.character(ngramlookuptablenostopwords$startstate)
# 
# unknownmaxnostopwords<-ddply(ngramlookuptablenostopwords, .(endstate, NgramSize), nrow)
# unknownmaxnostopwords<-lapply(split(unknownmaxnostopwords, unknownmaxnostopwords$NgramSize), function(x) {x[which.max(x$V1), c(1)]})
# unknownmaxnostopwords<-as.data.frame(do.call(rbind, unknownmaxnostopwords))
# unknownmaxnostopwords$ngramsize<-row.names(unknownmaxnostopwords)



# Define server logic
shinyServer(function(input, output) {
    
    #Render Input string
    output$inputtext <- renderText({
        
        input$goButton
        
        isolate({input$inputstringA})
    })
    
    output$outputstring<- renderText({
        
        
        input$goButton

        
        isolate({
        inputstring<-input$inputstringA
        inputstring<-removePunctuation(inputstring)
        inputstring<-tolower(inputstring)
        inputstring<-removeNumbers(inputstring)
        inputstring<-stripWhitespace(inputstring)
        
        outputstring<-subset(ngramlookuptable, startstate==inputstring)$endstate
        splitstr<-strsplit(inputstring, " ")[[1]]
        lengthofinput<-length(splitstr)
        ifelse(lengthofinput>3,
               inputstring <- paste(splitstr[lengthofinput - 2], splitstr[lengthofinput - 1], splitstr[lengthofinput], sep=" "),
               inputstring <- inputstring
               )
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
                    subset(ngramlookuptable, startstate==splitstr[2])$endstate,
                    NA
                )
            )
        )
        
        ifelse(
            is.na(outputstring),
            outputstring<-as.character(unknownmax[unknownmax$ngramsize==lengthofinput+1,]$V1[[1]]), #### need to change this to most common 4th, 3rd, or 2nd word
            outputstring<-outputstring
        )
        
        outputstring
        })
    })
    
    
#     output$outputstringnostop<- renderText({
#         
#         
#         input$goButton
#         
#         
#         isolate({
#             inputstring<-input$inputstringA
#             inputstring<-removePunctuation(inputstring)
#             inputstring<-tolower(inputstring)
#             inputstring<-removeNumbers(inputstring)
#             inputstring<-stripWhitespace(inputstring)
#             
#             outputstringnostop<-subset(ngramlookuptablenostopwords, startstate==inputstring)$endstate
#             splitstr<-strsplit(inputstring, " ")[[1]]
#             lengthofinput<-length(splitstr)
#             outputstringnostop<-ifelse(
#                 #If output string is in the table
#                 inputstring %in% ngramlookuptablenostopwords$startstate,
#                 #then return corresponding endstate
#                 subset(ngramlookuptablenostopwords, startstate==inputstring)$endstate, 
#                 #Else
#                 #if length of input string == 3
#                 ifelse(
#                     #if length of input string == 3
#                     lengthofinput==3,
#                     ifelse(
#                         paste(splitstr[2], splitstr[3], sep=" ") %in% ngramlookuptablenostopwords$startstate,
#                         subset(ngramlookuptablenostopwords, startstate==paste(splitstr[2], splitstr[3], sep=" "))$endstate,
#                         subset(ngramlookuptablenostopwords, startstate==splitstr[3])$endstate
#                     )
#                     ,
#                     ifelse(
#                         lengthofinput==2,
#                         subset(ngramlookuptablenostopwords, startstate==splitstr[2])$endstate
#                     )
#                 )
#             )
#             
#             ifelse(
#                 is.na(outputstringnostop),
#                 outputstringnostop<-as.character(unknownmaxnostopwords[unknownmaxnostopwords$ngramsize==lengthofinput+1,]$V1[[1]]), #### need to change this to most common 4th, 3rd, or 2nd word
#                 outputstringnostop<-outputstringnostop
#             )
#             ifelse(
#                 is.na(outputstringnostop),
#                 outputstringnostop<-"",
#                 outputstringnostop<-outputstringnostop
#             )
#             
#             
#             outputstringnostop
#         })
#     })
    
    
    
})