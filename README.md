# Gene Set Enrichment (PubWeb)

Workflow for performing gene set enrichment analysis from differential expression data

## Input Data

The input data for this workflow must consist of two files, a counts file and a
GMT geneset reference file. 

The counts file contains the 

### Counts Table Format

The counts table must be formatted as a CSV, with the file
extension '.csv[.gz]', as appropriate.

The counts table must have at least 2 columns: one for the gene ID, and a 'score' column showing relative expression levels for that gene (e.g. log2 fold change). There may be additional columns in the counts table, but they will be ignored
in this analysis.

### Genesets File

The `.gmt` file is a collection of gene sets, such as one of the [MSigDB](http://www.gsea-msigdb.org/gsea/downloads.jsp) datasets. 
