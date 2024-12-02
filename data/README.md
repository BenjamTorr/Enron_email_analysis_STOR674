# Data

If you run the analysis.R in the docker image or in your local computer this folder should contain several documents liste below:
- enron_mail_20150507/: This is the folder containing all the emails in txt form structure by folders. If you want to download it manually run /scripts/Rscripts/data_download.R or click [here](https://www.cs.cmu.edu/~enron/)
- GoogleNews-vectors-negative300.bin: This is the pretrained word2vec model, it is used for the user-specific classification model in ./results/word2vec_and_random_forest_classification.R. If you want to download it manually un /scripts/Rscripts/data_download.R or click [here](https://drive.google.com/file/d/0B7XkCwpI5KDYNlNUTTlSS21pQmM/edit?resourcekey=0-wjGZdNAUop6WykTtMip30g)
- cleaned_email_data.RData: This is the cleaned data that is used in all of the analysis. This is the most important document, it is obtained after running ./results/EDA.Rmd.

Authors: Yang Xiang and Benjamin Torres
