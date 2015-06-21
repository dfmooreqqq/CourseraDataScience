## Task0-1

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




## Reading in as a corpus

workingdir<-paste("C:\\Users", Sys.getenv("USERNAME"), "Documents\\GitHub\\DataScienceCapstone", sep = "\\")
setwd(workingdir)

cname<-file.path(".", "final", "en_US")


sparsity<-0.8

docs<- Corpus(DirSource(cname))

#sample docs first
perc_sampling = 0.1
docs[[1]]$content<-sample(docs[[1]]$content, length(docs[[1]]$content)*perc_sampling)
docs[[2]]$content<-sample(docs[[2]]$content, length(docs[[2]]$content)*perc_sampling*5)
docs[[3]]$content<-sample(docs[[3]]$content, length(docs[[3]]$content)*perc_sampling*0.4)

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x)) # create function that will let us convert things to a space
toRemove <- content_transformer(function(x, pattern) gsub(pattern, "", x)) # create function that will let us remove characters - such as apostrophes
docs<-tm_map(docs, toSpace, "/|@|\\|#~!@#$%^&*()_+:<>?,./;\"") # this will convert special characters (except apostrophe and hyphen) to a space in all the docs in the corpus
#docs<-tm_map(docs, toRemove, "'-") # this will remove apostrophes and hyphens
docs<-tm_map(docs, content_transformer(tolower)) # lower case everything
docs<-tm_map(docs, removeNumbers) # Remove the numbers
docs<-tm_map(docs, removePunctuation) # Remove punctuation
docs<-tm_map(docs, stripWhitespace) # Strip out the whitespace
#docs<-tm_map(docs, stemDocument) # this will remove common word endings for English words, such as es, ed, and s, and ing

#docs<-tm_map(docs, removeWords, stopwords("english")) # remove stopwords (do this because of exploration)
docs<-tm_map(docs, removeWords, c("fuck", "shit", "cock", "ass")) #remove other words

## Now, let's create our document term matrix

dtm<-DocumentTermMatrix(docs) ## This does the tokenizing
freq<-colSums(as.matrix(dtm))
length(freq)
ord<-order(freq)
freq[tail(ord)] # most common terms

# frequency of frequencies
head(table(freq), 15)
tail(table(freq), 15)


# Removing sparse terms

dtm<-removeSparseTerms(dtm, sparsity)
dim(dtm)
freqs<-colSums(as.matrix(dtm))

findFreqTerms(dtm, lowfreq=500)
findFreqTerms(dtm, lowfreq=100)
#plot(dtm, terms=findFreqTerms(dtm, lowfreq=500)[1:50], corThreshold=0.5)

##Plot Word Frequencies
freq<-sort(colSums(as.matrix(dtm)), decreasing=TRUE)
head(freq, 14)

wf<-data.frame(word=names(freq), freq=freq)
head(wf)

subset(wf, freq>head(freq,20)[20]-1) %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat="identity") +
    theme(axis.text.x=element_text(angle=45, hjust=1))

## Do word clouds
#set.seed(123)
#wordcloud(names(freq), freq, max.words=200, colors=brewer.pal(6, "Dark2"), rot.per=0.2)

#Assoc<-findAssocs(dtm, names(head(freq, 10)), corlimit=0.6)


######### Do 2-grams frequencies as well
BigramTokenizer<-function(x) NGramTokenizer(x, Weka_control(min=2, max=2))
dtm_bigram<-DocumentTermMatrix(docs, control=list(tokenize=BigramTokenizer))

freq_bigram<-colSums(as.matrix(dtm_bigram))
length(freq_bigram)
ord<-order(freq_bigram)
freq_bigram[tail(ord)] # most common terms

# freq_bigramuency of freq_bigramuencies
head(table(freq_bigram), 15)
tail(table(freq_bigram), 15)


# Removing sparse terms

dtm_bigram<-removeSparseTerms(dtm_bigram, sparsity)
dim(dtm_bigram)
freq_bigram<-colSums(as.matrix(dtm_bigram))

#findFreqTerms(dtm_bigram, lowfreq=500)
#findFreqTerms(dtm_bigram, lowfreq=1)
#plot(dtm_bigram, terms=findFreqTerms(dtm_bigram, lowfreq=50), corThreshold=0.5)

##Plot Word freq_bigramuencies
freq_bigram<-sort(colSums(as.matrix(dtm_bigram)), decreasing=TRUE)
#freq_bigrams<-sort(colSums(as.matrix(dtm_bigrams)), decreasing=TRUE)
head(freq_bigram, 20)

wf_bigram<-data.frame(word=names(freq_bigram), freq_bigram=freq_bigram)
#wf_bigrams<-data.frame(word=names(freq_bigrams), freq_bigram=freq_bigrams)

bigramsplit<-cbind(wf_bigram, colsplit(wf_bigram$word, " ", c("startstate", "endstate")))
# bigramtransitionmatrix<-xtabs(freq_bigram~word1+word2, bigramsplits)+0.01
# bigramtransitionmatrix<-t(apply(bigramtransitionmatrix, 1, function(x)(x/max(x))))

head(wf_bigram)

subset(wf_bigram, freq_bigram>head(freq_bigram,20)[20]-1) %>%
    ggplot(aes(word, freq_bigram)) +
    geom_bar(stat="identity") +
    theme(axis.text.x=element_text(angle=45, hjust=1))

## Do word clouds
#set.seed(123)
#wordcloud(names(freq_bigram), freq_bigram, max.words=50, colors=brewer.pal(6, "Dark2"), rot.per=0.2)

#Assoc_bigram<-findAssocs(dtm_bigram, names(head(freq_bigram, 10)), corlimit=0.6)

####### And TriGRams
TrigramTokenizer<-function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
dtm_trigram<-DocumentTermMatrix(docs, control=list(tokenize=TrigramTokenizer))

freq_trigram<-colSums(as.matrix(dtm_trigram))
length(freq_trigram)
ord<-order(freq_trigram)
freq_trigram[tail(ord)] # most common terms

# freq_bigramuency of freq_bigramuencies
head(table(freq_trigram), 15)
tail(table(freq_trigram), 15)


# Removing sparse terms

dtm_trigram<-removeSparseTerms(dtm_trigram, sparsity)
dim(dtm_trigram)
freq_trigram<-colSums(as.matrix(dtm_trigram))

#findFreqTerms(dtm_trigram, lowfreq=500)
#findFreqTerms(dtm_trigram, lowfreq=1)
#plot(dtm_trigram, terms=findFreqTerms(dtm_trigram, lowfreq=50), corThreshold=0.5)

##Plot Word freq_bigramuencies
freq_trigram<-sort(colSums(as.matrix(dtm_trigram)), decreasing=TRUE)
head(freq_trigram, 14)

wf_trigram<-data.frame(word=names(freq_trigram), freq_trigram=freq_trigram)
#wf_trigrams<-data.frame(word=names(freq_trigrams), freq_trigram=freq_trigrams)

trigramsplit<-cbind(wf_trigram, colsplit(wf_trigram$word, " ", c("word1", "word2", "endstate")))
trigramsplit$startstate<-paste(trigramsplit$word1, trigramsplit$word2, sep=" ")
# trigramtransitionmatrix<-xtabs(freq_trigram~startstate+word3, trigramsplits)+0.01
# trigramtransitionmatrix<-t(apply(trigramtransitionmatrix, 1, function(x)(x/max(x))))



head(wf_trigram)

subset(wf_trigram, freq_trigram>head(freq_trigram,20)[20]-1) %>%
    ggplot(aes(word, freq_trigram)) +
    geom_bar(stat="identity") +
    theme(axis.text.x=element_text(angle=45, hjust=1))

## Do word clouds
#set.seed(123)
#wordcloud(names(freq_trigram), freq_trigram, max.words=20, colors=brewer.pal(6, "Dark2"), rot.per=0.2)

#Assoc_bigram<-findAssocs(dtm_bigram, names(head(freq_bigram, 10)), corlimit=0.6)



####### And quadGRams
quadgramTokenizer<-function(x) NGramTokenizer(x, Weka_control(min=4, max=4))
dtm_quadgram<-DocumentTermMatrix(docs, control=list(tokenize=quadgramTokenizer))

freq_quadgram<-colSums(as.matrix(dtm_quadgram))
length(freq_quadgram)
ord<-order(freq_quadgram)
freq_quadgram[tail(ord)] # most common terms

# freq_bigramuency of freq_bigramuencies
head(table(freq_quadgram), 15)
tail(table(freq_quadgram), 15)


# Removing sparse terms

dtm_quadgram<-removeSparseTerms(dtm_quadgram, sparsity)
dim(dtm_quadgram)
freq_quadgram<-colSums(as.matrix(dtm_quadgram))

#findFreqTerms(dtm_quadgram, lowfreq=500)
#findFreqTerms(dtm_quadgram, lowfreq=1)
#plot(dtm_quadgram, terms=findFreqTerms(dtm_quadgram, lowfreq=50), corThreshold=0.5)

##Plot Word freq_bigramuencies
freq_quadgram<-sort(colSums(as.matrix(dtm_quadgram)), decreasing=TRUE)
head(freq_quadgram, 14)

wf_quadgram<-data.frame(word=names(freq_quadgram), freq_quadgram=freq_quadgram)
#wf_quadgrams<-data.frame(word=names(freq_quadgrams), freq_quadgram=freq_quadgrams)

quadgramsplit<-cbind(wf_quadgram, colsplit(wf_quadgram$word, " ", c("word1", "word2", "word3", "endstate")))
quadgramsplit$startstate<-paste(quadgramsplit$word1, quadgramsplit$word2, quadgramsplit$word3, sep=" ")
# quadgramtransitionmatrix<-xtabs(freq_quadgram~startstate+word4, quadgramsplits)+0.01
# quadgramtransitionmatrix<-t(apply(quadgramtransitionmatrix, 1, function(x)(x/max(x))))



head(wf_quadgram)

subset(wf_quadgram, freq_quadgram>head(freq_quadgram,20)[20]-1) %>%
    ggplot(aes(word, freq_quadgram)) +
    geom_bar(stat="identity") +
    theme(axis.text.x=element_text(angle=45, hjust=1))

rm(dtm, dtm_bigram, dtm_trigram, dtm_quadgram, freqs, ord, wf, wf_bigram, wf_trigram, wf_quadgram)

#########
## Create lookup tables for the most used endstate given a start state

"%w/o%" <- function(x, y) x[!x %in% y] #--  x without y
qgs<-quadgramsplit
quadgramsplit<-quadgramsplit[quadgramsplit$freq_quadgram!=1,]
max4gram<-lapply(split(quadgramsplit, quadgramsplit$startstate), function(x) {x[which.max(x$freq_quadgram), c(7,6)]})
max4gram<-as.data.frame(do.call(rbind, max4gram))
max4gram$NgramSize=4
u4grammax<-quadgramsplit[which.max(quadgramsplit$freq_quadgram),]$endstate
quadgramsplitnotstop<-quadgramsplit[(quadgramsplit$endstate) %w/o% (stopwords()),]
max4gramnostop<-lapply(split(quadgramsplitnotstop, quadgramsplitnotstop$startstate), function(x) {x[which.max(x$freq_quadgram), c(7,6)]})
max4gramnostop<-as.data.frame(do.call(rbind, max4gramnostop))
max4gramnostop$NgramSize=4
u4grammaxnostop<-quadgramsplitnotstop[which.max(quadgramsplitnotstop$freq_quadgram),]$endstate

tgs<-trigramsplit
trigramsplit<-trigramsplit[trigramsplit$freq_trigram!=1,]
max3gram<-lapply(split(trigramsplit, trigramsplit$startstate), function(x) {x[which.max(x$freq_trigram), c(6,5)]})
max3gram<-as.data.frame(do.call(rbind, max3gram))
max3gram$NgramSize=3
u3grammax<-trigramsplit[which.max(trigramsplit$freq_trigram),]$endstate
trigramsplitnotstop<-trigramsplit[(trigramsplit$endstate) %w/o% (stopwords()),]
max3gramnostop<-lapply(split(trigramsplitnotstop, trigramsplitnotstop$startstate), function(x) {x[which.max(x$freq_quadgram), c(6,5)]})
max3gramnostop<-as.data.frame(do.call(rbind, max3gramnostop))
max3gramnostop$NgramSize=3
u3grammaxnostop<-trigramsplitnotstop[which.max(trigramsplitnotstop$freq_quadgram),]$endstate

bgs<-bigramsplit
bigramsplit<-bigramsplit[bigramsplit$freq_bigram!=1,]
max2gram<-lapply(split(bigramsplit, bigramsplit$startstate), function(x) {x[which.max(x$freq_bigram), c(4,3)]})
max2gram<-as.data.frame(do.call(rbind, max2gram))
max2gram$NgramSize=2
u2grammax<-bigramsplit[which.max(bigramsplit$freq_bigram),]$endstate
bigramsplitnotstop<-bigramsplit[(bigramsplit$endstate) %w/o% (stopwords()),]
max2gramnostop<-lapply(split(bigramsplitnotstop, bigramsplitnotstop$startstate), function(x) {x[which.max(x$freq_quadgram), c(4,3)]})
max2gramnostop<-as.data.frame(do.call(rbind, max2gramnostop))
max2gramnostop$NgramSize=2
u2grammaxnostop<-bigramsplitnotstop[which.max(bigramsplitnotstop$freq_quadgram),]$endstate




ngramlookuptable<-rbind(max2gram, max3gram, max4gram)
ngramlookuptablenostopwords<-rbind(max2gramnostop, max3gramnostop, max4gramnostop)





library(data.table)
unknownmax<-ddply(ngramlookuptable, .(endstate, NgramSize), nrow)
unknownmax<-lapply(split(unknownmax, unknownmax$NgramSize), function(x) {x[which.max(x$V1), c(1)]})
unknownmax<-as.data.frame(do.call(rbind, unknownmax))
unknownmax$ngramsize<-row.names(unknownmax)

##### Okay, here's where you can get your most recommended suggestion
inputstring<-"aaron"
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



