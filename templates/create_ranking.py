#!/usr/bin/env python3

import logging
import os
import pandas as pd
import numpy as np


# Set up logging
logFormatter = logging.Formatter(
    '%(asctime)s %(levelname)-8s [create_ranking] %(message)s'
)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Write to STDOUT
consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(logFormatter)
logger.addHandler(consoleHandler)


def create_ranking(source_file,
                   destination_file
                   ):
    gene_id_col = "${params.gene_column}"
    score_col = "${params.score_column}"
    pval_col = "${params.pval_col}"
    ranking_method = "${params.rank_method}"

    de_results = pd.read_csv(source_file)

    if score_col not in de_results.columns:
        print(f"Error, score column {score_col} not in {source_file}")

    # We want to split the dataframe into positive and negative score_col values
    # sort them differently, and then join them again
    
    # make a deep copy to avoid sorting-on-slices gotchas with pandas
    de_results_positive = de_results[de_results[score_col] >= 0].copy(deep=True)

    # do an ascending sort (smallest pvalues at the top)
    de_results_positive.sort_values(pval_col,
                                    axis=0,
                                    ascending=True,
                                    inplace=True)

    # make a deep copy to avoid sorting-on-slices gotchas with pandas
    de_results_negative = de_results[de_results[score_col] < 0].copy(deep=True)

    # do an descending sort for negative score_col values (largest pvalues at the top)
    de_results_negative.sort_values(pval_col,
                                    axis=0,
                                    ascending=False,
                                    inplace=True)

    # concatenate the positive and negative values together
    # positives are first, so they are ranked at the top
    de_sorted = pd.concat([de_results_positive, de_results_negative])

    # save the results to a CSV, formatted to be easily used by fgsea
    de_sorted.to_csv(destination_file, 
                     columns=[gene_id_col, score_col],
                     index=False, 
                     header=True)


if __name__ == "__main__":
    source_file = "${de_result}"
    destination_file = "${params.rank_file_name}"

    # Make sure that the input file exists
    assert os.path.exists(source_file), f"File not found: {source_file}"

    create_ranking(source_file=source_file,
                   destination_file=destination_file)
