# Use the ARM64-compatible rocker image
FROM rocker/r2u:jammy

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install Git
RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the GitHub repository
# Replace <github-repo-url> with the actual URL of your repository
RUN git clone https://github.com/BenjamTorr/Enron_email_analysis_STOR674 /repo

WORKDIR /repo

# Install tidyverse in R
RUN install.r tidyverse rvest

# Command to run the R script
CMD ["Rscript", "analysis.R"]
