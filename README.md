# Enron email analysis STOR 674

## Authors:
Yang Xiang and Benjamin Torres, PhD students in Statistics at UNC.

## Goal:
This is the final project for the course STOR 674: Tools for Reproducible Data Science. We aim to create a data science project with a high reproducibility stards.
The specific dataset and analysis is related to the ENRON email dataset, description and data available [here](https://www.cs.cmu.edu/~enron/). In this project we will run some exploratory analysis, we will try to understand the dynamics of the emails inside ENRON corporation and we run and additional user-specific classification model that learns how to classify emails into user-specific folders. 
## Structure:
```
The structure of the project is the following
----Structure-------------------------------------------------- ---------------------------Explanation-------------------|
├── Images                                                  | Folder where auto-generated images from the analysis will be saved in this folder once its run.
│   ├── README.md                                           | Explanation of the images names
├── data                                                    | Folder where the data will be downloaded/should be located
│   ├── README.md                                           | Explanation of the files that are contained
├── models                                                  | Folder where the models for user-specific folder classification will be saved.
│   ├── README.md                                           | Explanation of the files type.
├── Dockerfile                                              | Run the docker file to build the docker image
├── results                                                 | This folder containts the R script related to the analysis itself.
│   ├── EDA.Rmd                                             | Run the Rmd from the raw data and obtain the clean data
|   |── graph_analysis.R                                    | Creates igraph visualization for the data
|   |── skip_gram_plus_clustering.R                         | Creates user clustering and visualize the interaction between users
|   |── word2vec_and_random_forest_classification.R         | Creates user-specific classification model
|   |── wordcloud_analysis.R                                | Creates a wordcloud of the content of the emails.
│   └── README.md                                           | More detailed explanation of the content
├── scripts                                                 | Folder where the data processing scripts and main functions
│   └── RScripts                                            |
│       ├── analysis_utils.R                                | Main functions for the scripts in results folder
|       ├── data_download.R                                 | When sourced it will download the raw data and the pretraine word2vec model for classification
|       ├── data_utils.R                                    | Main preprocessing functions 
|       ├── unit_test.R                                     | Tests for the data_utils functions
|       ├── README.md                                       | More detailed explaination for the context of the folder
├── .gitignore                                              | Files that are ignored for git
├── README.md                                               | This file
├── analysis.R                                              | Master script that runs the whole analysis
└── run_analysis.R                                          | Bash script that runs analysis.R
-----------------------------------------------------------------------------------------------------
```
## How to run it?
### Via script
Use the docker image built to run the analysis using the analysis.R script or if you already have a system with R installled run analysis.R. 

For the dockerfile, use the following command to build the docker image

```bash
docker build -t my_image . 
```

Then run the following to get data processing and analysis results. This takes about 70 minutes.

```bash
docker run my_image 
```

Once this process is done, you can run the following to check  the results.

```bash
docker run -it my_image /bin/bash
```bash

### Manually
  -  Install R/Rstudio
  -  Install the packages listed in the analysis.R script
  -  source(scripts/Rscripts/data_download.R) to download the data and word2vec pretrained model if not already downloaded
  -  Run the EDA.Rmd to see the analysis but also the get the clean data in format "./data/cleaned_email_data.RData" into data folder (this is key step)
  -  Run of the results scripts that are of interest
  -   If anything goes wrong in this step, please run the ./scripts/Rscripts/unit_test.R to check if the preprocessing functions are working well.


