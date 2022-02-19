#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2


// Set default parameters
params.help = false

params.rank_method = 'logfold-stddev'
params.output_dir = 'gsea'
params.rank_file_name = 'rankings.csv'

params.gene_column = 'gene_id'
params.score_column = 'log2FoldChange'

// Set the containers to use for each component
params.container__pandas = "quay.io/fhcrc-microbiome/python-pandas:0fd1e29"
params.container__fgsea = "quay.io/biocontainers/bioconductor-fgsea:1.20.0--r41h399db7b_0"
params.container__gseapy = "quay.io/biocontainers/gseapy:0.10.7--pyhdfd78af_0"


// Import modules
include { geneset_enrichment } from './modules/geneset_enrichment.nf'


// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run FredHutch/pw-gene-set-enrichment <ARGUMENTS>

Input Data:
  --counts_file         CSV file containing expression counts of genes to cell types
  --genesets_file       .GMT file containing the gene sets to use
                        This is currently tested using the 'msigdb' sets
                        from http://www.gsea-msigdb.org/

Required Arguments:
  --output_dir          Folder to write output files to

Optional Arguments:
  --rank_method         Sample normalization method. Choose from {‘logfold-stddev’}. Default: logfold-stddev.
  --score_column        The name of the column in the counts_file to use to create gene rank. Default: log2FoldChange
  --gene_column         The name of the column in the counts file with gene ids. Default: gene_id
  --rank_file_name      The name of the file to create that has ranking data. Default: rankings.csv
    """.stripIndent()
}


// Main workflow
workflow {

    // Show help message if the user specifies the --help flag at runtime
    // or if --output_dir is not provided
    if ( params.help || params.output_dir == false ){
        // Invoke the function above which prints the help message
        helpMessage()
        // Exit out and do not run anything else
        exit 1
    }

    // If either the --counts_file or --genesets_file are not provided
    if ( !params.counts_file || !params.genesets_file){
        log.info"""
        ERROR: Must provide both --counts_file and --genesets_file
        View help text with --help for more details.
        """.stripIndent()
        exit 1
    }

    // If the file specified by --counts_file does not exist
    if ( params.counts_file && !file(params.counts_file).exists() ) {
        log.info"""
        ERROR: --counts_file file ${params.counts_file} does not exist
        """.stripIndent()
        exit 1
    }

    // If the file specified by --counts_file does not exist
    if ( params.genesets_file && !file(params.genesets_file).exists() ) {
        log.info"""
        ERROR: --genesets_file file ${params.genesets_file} does not exist
        """.stripIndent()
        exit 1
    }

    // Run geneset enrichment
    geneset_enrichment()
}