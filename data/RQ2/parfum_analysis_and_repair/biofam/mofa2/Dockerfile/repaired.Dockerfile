FROM r-base:4.0.2

WORKDIR /mofa2
ADD . /mofa2

RUN apt-get update && apt-get install -y -f && apt-get install --no-install-recommends -y python3 python3-setuptools python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcairo2-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libxt-dev libharfbuzz-dev libfribidi-dev && rm -rf /var/lib/apt/lists/*;

# Install mofapy2
RUN python3 -m pip install 'https://github.com/bioFAM/mofapy2/tarball/master'

# Install bioconductor dependencies
RUN R --vanilla -e "\
  if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos = 'https://cran.r-project.org'); \
  sapply(c('rhdf5', 'dplyr', 'tidyr', 'reshape2', 'pheatmap', 'corrplot', \
           'ggplot2', 'ggbeeswarm', 'scales', 'GGally', 'doParallel', 'RColorBrewer', \
           'cowplot', 'ggrepel', 'foreach', 'reticulate', 'HDF5Array', 'DelayedArray', \
           'ggpubr', 'forcats', 'Rtsne', 'uwot', \
           'systemfonts', 'ragg', 'Cairo', 'ggrastr', 'basilisk', 'mvtnorm'), \ 
         BiocManager::install)"
RUN R CMD INSTALL --build .

CMD []
