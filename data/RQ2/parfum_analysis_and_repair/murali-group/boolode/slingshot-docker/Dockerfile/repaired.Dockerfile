########
## Operating System
########

### OS version
FROM ubuntu:xenial
MAINTAINER Kelly Street, street.kelly@gmail.com

######################
## Environment
######################

## Constants
ENV R_VERSION 3.5.1-1xenial

### locations
ENV BIN /usr/local/bin
ENV R_DATA /usr/local/R/data
ENV R_STUDIO /usr/local/R
ENV SRC /usr/local/src

######################
## Dependencies and Tools
######################
##############
## Helper tools
RUN apt-get clean && apt-get update && \
    apt-get install --no-install-recommends -y unzip wget git && rm -rf /var/lib/apt/lists/*;

##############
## System tools
RUN apt-get install --no-install-recommends -y libssl-dev libcurl4-openssl-dev libgsl-dev \
    libxml2-dev libxt-dev libglu1-mesa-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/*;

##############
## Install R
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial-cran35/" | tee -a /etc/apt/sources.list && \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    gpg --batch -a --export E084DAB9 | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y r-recommended=${R_VERSION} && \
    apt-get install --no-install-recommends -y r-base=${R_VERSION} && rm -rf /var/lib/apt/lists/*;
RUN Rscript -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'

##############
## BiocManager for installing bioconductor packages
RUN echo "BiocManager::install(c(\"devtools\", \"remotes\", \"clusterExperiment\", \"drisso/fletcher2017data\", \"optparse\", \"logging\"), dependencies=TRUE)" > ${SRC}/install_pkgs.R  && \
    echo "BiocManager::install(\"slingshot\", INSTALL_opts = c(\"--install-tests\"))" >> ${SRC}/install_pkgs.R && \
    Rscript ${SRC}/install_pkgs.R

##############
## Install wrapper script
RUN mkdir /data/
COPY run_slingshot.R /data/
