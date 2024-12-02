############################
###########################
##
## This is the master R script that runs the complete analysis from scratch
##
##
##
##############################

#---------------------------Packages download -------------------------------------#

options(repos = c(CRAN = "https://cloud.r-project.org/"))

packages = c('tidyverse', 'testthat', 'assertthat', 'here', 'caret', 'randomForest', 'word2vec', 'ggplot2',
             'tm', 'wordcloud', 'RColorBrewer', 'igraph', 'rmarkdown', 'knitr')

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
cat(str(rmarkdown::pandoc_version()))
library(knitr)
#------------------------ Run analysis -------------------------------------------#
cat('\n\n\n')
cat('-------------------Generating EDA this may take a while -----------------------\n')
library(knitr)
knit('results/EDA.Rmd', output = 'results/EDA.md')

cat('-------------------Generating Wordcloud-----------------------\n')
cat('\n\n')
source('results/wordcloud_analysis.R')
cat('--------------------Generating graph connectivity-------------\n\n')
source('results/graph_analysis.R')
cat('--------------------Generating user clustering----------------\n\n')
source('results/skip_gram_plus_clustering.R')
cat('--------------------Generating user classification model------\n\n')
source('results/word2vec_and_random_forest_classification.R')

#---------------------------------------------------------------------------------#