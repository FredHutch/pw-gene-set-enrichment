#!/usr/bin/env Rscript
library(fgsea)
library(data.table)
set.seed(42)

# load in the GMT file
pathways <- gmtPathways("${gmt}")


# load in the ranking data
ranks <- read.csv("${ranking}",
                    header=TRUE, colClasses = c("character", "numeric"))

ranks2 <- c(ranks\$"${params.score_column}")
names(ranks2) <- c(ranks\$"${params.gene_column}")

# run fgsea, get the resulting object
# the minSize & maxSize defaults from the tutorial
fgseaRes <- fgsea(pathways = pathways, 
                  stats    = ranks2,
                  minSize  = 15,
                  maxSize  = 500)

fwrite(fgseaRes[order(pval), ], file="gsea.csv", sep=",", sep2=c("", " ", ""))



