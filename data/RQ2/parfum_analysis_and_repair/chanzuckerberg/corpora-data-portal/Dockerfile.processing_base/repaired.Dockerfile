FROM rocker/r-ver:4.0.3

# Most of these are required for SCE
RUN apt-get update && apt-get -yq --no-install-recommends install \
      cpio \
      git \
      jq \
      python3-pip \
      zlib1g-dev \
      libbz2-dev \
      liblzma-dev \
      libcurl4-openssl-dev \
      libglpk-dev \
      libxml2-dev \
      wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* && \
  # Install R dependencies
  R -e "install.packages('BiocManager')" && \
  R -e "BiocManager::install('SingleCellExperiment')" && \
  # note: Loom format has been deprecated from cellxgene but cellgeni/sceasy has a dependency on LoomExperiment
  #       See https://github.com/cellgeni/sceasy#installation
  R -e "BiocManager::install('LoomExperiment')" && \
  R -e "install.packages(c('devtools', 'igraph'));" && \
  R -e "library(devtools); devtools::install_github('cellgeni/sceasy')" && \
  R -e "install.packages('Seurat',dependencies=TRUE, repos='http://cran.rstudio.com/')"
