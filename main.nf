#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2


// Set default parameters
params.help = false
params.input_csv = false
params.genesets_file = false
params.output_dir = false


// Import modules
include { geneset_enrichment } from './modules/geneset_enrichment.nf'


// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run FredHutch/pw-gene-set-enrichment <ARGUMENTS>

Input Data:
  --input_csv.          CSV file containing differential expression results of genes, log-fold change and p_values
  --genesets_file       .GMT file containing the gene sets to use
                        This is currently tested using the 'msigdb' sets
                        from http://www.gsea-msigdb.org/

Required Arguments:
  --output_dir          Folder to write output files to

Optional Arguments:
  --rank_method         Sample normalization method. Choose from {‘logfold-stddev’}. Default: logfold-stddev.
  --score_column        The name of the column in the input_csv to use to create gene rank. Default: logFC
  --pval_column         The name of the column in the input_csv that has p_values for the score column. Default: pvalue
  --gene_column         The name of the column in the input_csv with gene ids. Default: gene_id
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

    // If either the --input_csv or --genesets_file are not provided
    if ( !params.input_csv || !params.genesets_file){
        log.info"""
        ERROR: Must provide both --input_csv and --genesets_file
        View help text with --help for more details.
        """.stripIndent()
        exit 1
    }

    // If the file specified by --input_csv does not exist
    if ( params.input_csv && !file(params.input_csv).exists() ) {
        log.info"""
        ERROR: --input_csv file ${params.input_csv} does not exist
        """.stripIndent()
        exit 1
    }

    // If the file specified by --genesets_file does not exist
    if ( params.genesets_file && !file(params.genesets_file).exists() ) {
        log.info"""
        ERROR: --genesets_file file ${params.genesets_file} does not exist
        """.stripIndent()
        exit 1
    }

    // Run geneset enrichment
    geneset_enrichment()
}