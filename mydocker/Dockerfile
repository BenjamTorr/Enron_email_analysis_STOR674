# Base image
FROM rocker/r-ver:4.4.1

LABEL description="Docker image for running R scripts."

# Install R packages
RUN R -e "install.packages(c('tidyverse', 'igraph', 'word2vec', 'caret', 'randomForest'), repos='http://cran.rstudio.com/')"

# Set working directory
WORKDIR /docker

# Copy project files
COPY data_utils.R /docker/data_utils.R

CMD ["Rscript","data_utils.R"]
