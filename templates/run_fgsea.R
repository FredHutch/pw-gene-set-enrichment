#!/usr/bin/env Rscript

#install.packages('readr')

library(fgsea)
library(data.table)
library(ggplot2)
set.seed(42)
#library(readr)



# load in the GMT file
pathways <- gmtPathways("${gmt}")


# load in the ranking data
ranks <- read.csv("${ranking}",
                    header=TRUE, colClasses = c("character", "numeric"))

ranks2 <- c(ranks\$ranking_score)
names(ranks2) <- c(ranks\$gene_id)

fgseaRes <- fgsea(pathways = pathways, 
                  stats    = ranks2,
                  minSize  = 15,
                  maxSize  = 500)

fwrite(fgseaRes[order(pval), ], file="gsea.csv", sep=",", sep2=c("", " ", ""))

collapsedPathways <- collapsePathways(fgseaRes[order(pval)][padj < 0.01], 
                                      pathways, ranks2)

mainPathways <- fgseaRes[pathway %in% collapsedPathways\$mainPathways][
                         order(-NES), pathway]

#fwrite(mainPathways, file="mainPathways.csv", sep=",", sep2=c("", " ", ""))

#fwrite(collapsedPathways\$parentPathways, file="parentPathways.csv", sep=",", sep2=c("", " ", ""))


