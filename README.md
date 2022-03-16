# Gene Set Enrichment (PubWeb)

Workflow for performing gene set enrichment analysis from differential expression data

## Input Data

The input data for this workflow must consist of two files, an input csv file and a
GMT geneset reference file. 

The input CSV file contains the 

### Input CSV Format

The input csv must be formatted as a CSV, with the file
extension '.csv[.gz]', as appropriate.

The input csv must have at least 3 columns: one for the gene ID, a 'score' column showing relative expression levels for that gene (e.g. log2 fold change), and a p-value column. There may be additional columns in the csv, but they will be ignored
in this analysis.

### Genesets File

The `.gmt` file is a collection of gene sets, such as one of the [MSigDB](http://www.gsea-msigdb.org/gsea/downloads.jsp) datasets. 
