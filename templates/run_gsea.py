#!/usr/bin/env python3

import logging
import pandas as pd
import os
import gseapy as gp


# Set up logging
logFormatter = logging.Formatter(
    '%(asctime)s %(levelname)-8s [validate_manifest] %(message)s'
)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Write to STDOUT
consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(logFormatter)
logger.addHandler(consoleHandler)


def run_single_sample_gsea(de_results_file,
                           genesets_file,
                           output_dir,
                           rank_method,
                           process_count):
    ss = gp.ssgsea(data=de_results_file,
                   gene_sets=genesets_file,
                   outdir=output_dir,
                   sample_norm_method=rank_method,  # choose 'custom' for your own rank list
                   permutation_num=0,  # skip permutation procedure, because you don't need it
                   no_plot=True,  # skip plotting, because you don't need these figures
                   processes=process_count,
                   format='png',
                   seed=9)


def run_gsea(de_results_file,
             genesets_file,
             gsea_method,
             output_dir,
             permutation_type,
             permutation_num):

    # Read in the differential expression counts file
    logger.info(f"Reading in {de_results_file}")
    df = pd.read_csv(de_results_file, sep=de_file_separator, index_col=0)

    # Generate the class labels
    df.drop('gene_name', axis=1, inplace=True)
    class_labels = [x for x in df.columns[1:]]

    # Run the gsea command
    gsea(data=de_results_file,
         gene_sets=genesets_file,
         cls=class_labels,
         method=gsea_method,
         outdir=output_dir,
         permutation_type=permutation_type,
         permutation_num=permutation_num)


if __name__ == "__main__":
    de_results_file = "${params.counts_file}"
    genesets_file = "${params.genesets_file}"
    # gsea_method = "${params.gsea_method}" #t-test
    # permutation_type = "${params.permutation_type}" #phenotype
    # permutation_num = int("${params.permutation_num}")
    process_count = int("${task.cpus}")
    output_dir = "gsea"
    rank_method = "${params.rank_method}"

    # Make sure that the input files exist
    assert os.path.exists(de_results_file), f"File not found: {de_results_file}"
    assert os.path.exists(genesets_file), f"File not found: {genesets_file}"

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    run_single_sample_gsea(de_results_file,
                           genesets_file,
                           output_dir,
                           rank_method,
                           process_count)
