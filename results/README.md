# Data Analysis

This folder contains the analysis of the Enron dataset. 
- "EDA.Rmd": is the fundamental exploration of the Enron dataset. 
- "graph_analysis.R": gives the graph analysis of interactions between all active Enron users. This document requires data/cleaned_email_data.RData see data folder for more information
- "skip_gram_plus_clustering.R": gives the analysis of the clustering of all actively interacted usernames using word2vec embeddings. This document requires data/cleaned_email_data.RData see data folder for more information
-"word2vec_and_random_forest_classification.R": uses word2vec embedding and random forest to do folder classification for each person. This document requires data/cleaned_email_data.RData see data folder for more information
-"wordcloud_analysis.R:" uses wordcloud to illustrate the most frequently appeared words in the content of emails.This document requires data/cleaned_email_data.RData see data folder for more information

Authors: Yang Xiang and Benjamin Torres
