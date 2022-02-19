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


# Takes a single DataFrame row and returns a ranking value
def get_ranking_data(row, method, score_col, std_dev=1.0):
    # additional methods can be added easily
    if method == 'logfold-stddev':
        return row[score_col] / std_dev
    else:
        return row[score_col]


def create_ranking(source_file,
                   destination_file,
                   score_col,
                   gene_id_col,
                   ranking_method
                   ):
    de_results = pd.read_csv(source_file)

    # calculate the logfold column's standard deviation
    std_dev = np.std(de_results[score_col], ddof=1)

    # Get the ranking score for each record using the get_ranking_data() method
    de_results['ranking_score'] = de_results.apply(get_ranking_data,
                                                   method=ranking_method,
                                                   score_col=score_col,
                                                   std_dev=std_dev,
                                                   axis=1)

    # sort values from largest to smallest
    de_results.sort_values('ranking_score',
                           axis=0,
                           ascending=False,
                           inplace=True)

    # save the results to a CSV, formatted to be easily used by fgsea
    de_results.to_csv(destination_file, 
                      columns=[gene_id_col, 'ranking_score'],
                      index=False, 
                      header=True)


if __name__ == "__main__":
    source_file = "${de_result}"
    destination_file = "${params.rank_file_name}"
    gene_id_col = "${params.gene_column}"
    score_col = "${params.score_column}"
    ranking_method = "${params.rank_method}"

    # Make sure that the input file exists
    assert os.path.exists(source_file), f"File not found: {source_file}"

    create_ranking(source_file=source_file,
                   destination_file=destination_file,
                   score_col=score_col,
                   gene_id_col=gene_id_col,
                   ranking_method=ranking_method)
