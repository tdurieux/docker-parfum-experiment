### Single-cell analysis pipeline for "Integrated analysis and regulation of cellular diversity"
# Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot
# ArchR

# splatter is an R script and cannot be installed by command
# https://github.com/MarioniLab/MNN2017/
# pyscenic

FROM rnakato/r_python:r35u18
LABEL maintainer "Ryuichiro Nakato <rnakato@iam.u-tokyo.ac.jp>"

USER root
WORKDIR /opt

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    emacs25-el \
    libgsl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

# Python
RUN conda install -y -c bioconda samtools scanpy kallisto \
    && conda install -y -c statiskit libboost \
    && pip install --no-cache-dir -U velocyto

RUN  R -e "install.packages(c('sleepwalk','bit64','zoo','scBio','Seurat'), repos='https://cran.ism.ac.jp/')" \
     && R -e "BiocManager::install(c('limma','scater','pcaMethods','WGCNA','preprocessCore', 'RCA', 'scmap', 'mixtools', 'stringi', 'rbokeh', 'DT', 'NMF', 'pheatmap', 'R2HTML', 'doMC', 'doRNG', 'scran', 'slingshot','DropletUtils','SingleR', 'monocle', 'scTensor','chromVAR'))" \
    && R -e "devtools::install_github(c('Vivianstats/scImpute', 'alexisvdb/singleCellHaystack', 'MacoskoLab/liger','aertslab/SCopeLoomR', 'velocyto-team/velocyto.R'))"

RUN R -e "install.packages(c('scBio','Seurat'), repos='https://cran.ism.ac.jp/')"
RUN R -e "devtools::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())"

# Monocle3
RUN R -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'limma', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment', 'batchelor'))" \
    && R -e "devtools::install_github('cole-trapnell-lab/leidenbase')" \
    && R -e "devtools::install_github('cole-trapnell-lab/monocle3', ref='develop')" \
    && R -e "BiocManager::install(c('org.Mm.eg.db', 'org.Hs.eg.db', 'org.Dm.eg.db', 'org.Ce.eg.db'))" \
    && R -e "devtools::install_github('cole-trapnell-lab/garnett', ref='monocle3')"

# cicero
RUN R -e "devtools::install_github('cole-trapnell-lab/cicero-release', ref = 'monocle3')"

# kallisto, bustools
RUN git clone https://github.com/BUStools/bustools.git \
    && cd bustools \
    && mkdir build \
    && cd build \
    && cmake .. && make && make install \
    && R -e "devtools::install_github(c('tidymodels/tidymodels','BUStools/BUSpaRse'))" \
    && rm -rf /opt/bustools
