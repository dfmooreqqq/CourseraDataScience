### Read the other ngrams

w2<-read.delim("ngrams/w2_.txt", header=FALSE); names(w2)<-c("frequency", "word1", "endstate")
w3<-read.delim("ngrams/w3_.txt", header=FALSE); names(w3)<-c("frequency", "word1", "word2", "endstate")
w4<-read.delim("ngrams/w4_.txt", header=FALSE); names(w4)<-c("frequency", "word1", "word2", "word3", "endstate")
w5<-read.delim("ngrams/w5_.txt", header=FALSE); names(w5)<-c("frequency", "word1", "word2", "word3", "word4", "endstate")


w2_<-data.frame(word = paste(w2$word1, w2$endstate), freq_bigram=w2$frequency, startstate=w2$word1, endstate=w2$endstate)
w3_<-data.frame(word = paste(w3$word1, w3$word2, w3$endstate), freq_trigram=w3$frequency, startstate= paste(w3$word1, w3$word2), endstate=w3$endstate)
w4_<-data.frame(word = paste(w4$word1, w4$word2, w4$word3, w4$endstate), freq_quadgram=w4$frequency, startstate= paste(w4$word1, w4$word2, w4$word3), endstate=w4$endstate)
w5_<-data.frame(word = paste(w5$word1, w5$word2, w5$word3, w5$word4, w5$endstate), freq_quintgram=w5$frequency, startstate= paste(w5$word1, w5$word2, w5$word3, w5$word4), endstate=w5$endstate)

"%w/o%" <- function(x, y) x[!x %in% y] #--  x without y
qgs<-w4_
w4split<-w4_[w4_$freq_w4!=1,]
max4gram_alt<-lapply(split(w4split, w4split$startstate), function(x) {x[which.max(x$freq_w4), c(7,6)]})
max4gram_alt<-as.data.frame(do.call(rbind, max4gram_alt))
max4gram_alt$NgramSize=4
u4grammax_alt<-w4split[which.max(w4split$freq_w4),]$endstate
w4splitnotstop<-w4split[(w4split$endstate) %w/o% (stopwords()),]
max4gram_altnostop<-lapply(split(w4splitnotstop, w4splitnotstop$startstate), function(x) {x[which.max(x$freq_w4), c(7,6)]})
max4gram_altnostop<-as.data.frame(do.call(rbind, max4gram_altnostop))
max4gram_altnostop$NgramSize=4
u4grammax_altnostop<-w4splitnotstop[which.max(w4splitnotstop$freq_w4),]$endstate

tgs<-w3_
w3<-w3_[w3_$freq_trigram!=1,]
max3gram_alt<-lapply(split(w3, w3$startstate), function(x) {x[which.max(x$freq_trigram), c(6,5)]})
max3gram_alt<-as.data.frame(do.call(rbind, max3gram_alt))
max3gram_alt$NgramSize=3
u3grammax_alt<-w3[which.max(w3$freq_trigram),]$endstate
w3notstop<-w3[(w3$endstate) %w/o% (stopwords()),]
max3gram_altnostop<-lapply(split(w3notstop, w3notstop$startstate), function(x) {x[which.max(x$freq_w4), c(6,5)]})
max3gram_altnostop<-as.data.frame(do.call(rbind, max3gram_altnostop))
max3gram_altnostop$NgramSize=3
u3grammax_altnostop<-w3notstop[which.max(w3notstop$freq_w4),]$endstate

bgs<-w2_
w2<-w2_[w2_$freq_bigram!=1,]
max2gram_alt<-lapply(split(w2, w2$startstate), function(x) {x[which.max(x$freq_bigram), c(4,3)]})
max2gram_alt<-as.data.frame(do.call(rbind, max2gram_alt))
max2gram_alt$NgramSize=2
u2grammax_alt<-w2[which.max(w2$freq_bigram),]$endstate
w2notstop<-w2[(w2$endstate) %w/o% (stopwords()),]
max2gram_altnostop<-lapply(split(w2notstop, w2notstop$startstate), function(x) {x[which.max(x$freq_w4), c(4,3)]})
max2gram_altnostop<-as.data.frame(do.call(rbind, max2gram_altnostop))
max2gram_altnostop$NgramSize=2
u2grammax_altnostop<-w2notstop[which.max(w2notstop$freq_w4),]$endstate