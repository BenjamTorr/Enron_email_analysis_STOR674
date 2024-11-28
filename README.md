# Project for STOR 674

To get the Enron dataset, you can run the ./scripts/Rscripts/data_download.R or manually download it from http://www.cs.cmu.edu/~enron/ and put it under ./data for further analysis.

After the data is prepared, you can run the ./results/EDA.Rmd to do data preprocessing and exploration. Running this file will get you an output file "cleaned_email_data.RData" in the data folder. This is the extracted data from the dataset for further analysis. If anything goes wrong in this step, please run the ./scripts/Rscripts/unit_test.R to check if the preprocessing functions are working well.

After you get "./data/cleaned_email_data.RData", you can run the other files under ./results to check the results of our analysis.

To be updated...

Authors: Yang Xiang and Benjamin Torres
