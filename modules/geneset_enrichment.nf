#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2


// Create the ranking data from 
// All parameters are passed in directly to the template script
process create_ranking {
    container "${params.container__pandas}"
    label "io_limited"
    publishDir "${params.output_dir}", mode: "copy", overwrite: true
    
    input:
    path de_result, stageAs: "*"

    output:
    path "$params.rank_file_name"

    script:
    // Run the script in templates/create_ranking.py
    template "create_ranking.py"

}




// Run gene set enrichment
// All parameters are passed in directly to the template script
process run_fgsea {
    container "${params.container__fgsea}"
    label "mem_medium"
    publishDir "${params.output_dir}/gsea/", mode: "copy", overwrite: true
    
    input:
    path ranking, stageAs: "rank/*"
    path gmt, stageAs: "gmt/*"

    output:
    path "*.csv"

    script:
    // Run the script in templates/run_gsea.R
    template "run_fgsea.R"

}



workflow geneset_enrichment {

    main:
        counts_ch = Channel.fromPath(params.counts_file)

        // Run the ranking
        create_ranking(counts_ch)

        // Get the gmt file
        gmt_ch = Channel.fromPath(params.genesets_file)

        // Run gene set enrichment. 
        run_fgsea(create_ranking.out,
            gmt_ch)

}