### Single-cell analysis pipeline for "Integrated analysis and regulation of cellular diversity"
# Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot

# splatter is an R script and cannot be installed by command
# https://github.com/MarioniLab/MNN2017/
#pyscenic

#FROM rnakato/ubuntu:dorowu-bionic
FROM dorowu/ubuntu-desktop-lxde-vnc
LABEL maintainer "Ryuichiro Nakato <rnakato@iam.u-tokyo.ac.jp>"

USER root

ENV PATH /opt/conda/bin:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-file \
    apt-utils \
    build-essential \
    bzip2 \
    ca-certificates \
    cmake \
    curl \
    emacs \
    eog \
    evince \
    gawk \
    gedit \
    gfortran \
    git \
    gnupg \
    hdf5-helpers \
    htop \
    imagemagick \
    libblas-dev \
    libboost-all-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libgdal-dev \
    libglu1-mesa-dev \
    libhdf5-dev \
    liblapack3 \
    liblapack-dev \
    libssl-dev \
    libudunits2-dev \
    libx11-dev \
    make \
    openjdk-8-jdk-headless \
    openjdk-8-jre \
    pigz \
    sra-toolkit \
    unzip \
    vim \
    xorg \
    zlib1g-dev \
       emacs \
       git \
       language-pack-ja-base \
       language-pack-ja \
       locales \
       make \
       vim \
       wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial.so.100 /usr/lib/x86_64-linux-gnu/libhdf5.so.100 \
    && ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial_hl.so.100 /usr/lib/x86_64-linux-gnu/libhdf5_hl.so.100

# FFTW, FIt-SNE
RUN wget https://www.fftw.org/fftw-3.3.8.tar.gz \
    && tar zxvf fftw-3.3.8.tar.gz \
    && rm fftw-3.3.8.tar.gz \
    && cd fftw-3.3.8 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && git clone https://github.com/KlugerLab/FIt-SNE.git \
    && cd FIt-SNE/ \
    && g++ -std=c++11 -O3  src/sptree.cpp src/tsne.cpp src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm \
    && cp bin/fast_tsne /usr/local/bin/

# Anaconda3 (2019.10)
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O /root/anaconda.sh \
     && bash /root/anaconda.sh -b -p /opt/conda \
     && rm /root/anaconda.sh \
     && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

# Python
RUN conda update -y conda
RUN conda config --add channels conda-forge \
    && conda install -y numpy numpy_groupies scipy pandas cython numba matplotlib scikit-learn h5py click python-igraph louvain umap-learn jupyter jupyterlab libgdal \
    && conda install -y -c bioconda samtools scanpy \
    && conda install -y -c statiskit libboost \
    && pip install --no-cache-dir -U velocyto

# R
RUN conda install -y -c r r-units \
    && ln -s /bin/tar /bin/gtar
RUN wget https://cran.r-project.org/src/contrib/curl_4.3.tar.gz \
    && R CMD INSTALL curl_4.3.tar.gz --configure-vars="INCLUDE_DIR=/usr/lib/x86_64-linux-gnu/pkgconfig/ LIB_DIR=/usr/lib/x86_64-linux-gnu/pkgconfig/"

RUN  R -e "install.packages(c('Rcpp','devtools','BiocManager','igraph','sleepwalk','bit64','zoo','hdf5r'), repos='https://cran.ism.ac.jp/')" \
     && R -e "BiocManager::install(c('limma','scater','pcaMethods','WGCNA','preprocessCore', 'RCA', 'scmap', 'mixtools', 'stringi', 'rbokeh', 'DT', 'NMF', 'pheatmap', 'R2HTML', 'doMC', 'doRNG', 'scran', 'slingshot'))" \
    && R -e "devtools::install_github(c('Vivianstats/scImpute', 'alexisvdb/singleCellHaystack', 'aertslab/SCopeLoomR', 'MacoskoLab/liger', 'velocyto-team/velocyto.R'))"

# scBio
RUN R -e "install.packages(c('scBio'), repos='https://cran.ism.ac.jp/')"

# Seurat
RUN R -e "BiocManager::install(c('multtest'))" \
    && R -e "install.packages(c('Seurat'), repos='https://cran.ism.ac.jp/')"
