# Single-cell analysis pipeline for "Integrated analysis and regulation of cellular diversity"

FROM rnakato/r_python_gpu:2020.12
LABEL maintainer "Ryuichiro Nakato <rnakato@iqb.u-tokyo.ac.jp>"

USER root
WORKDIR /opt

ARG GITHUB_PAT
RUN set -x && \
    echo "GITHUB_PAT=$GITHUB_PAT" > ~/.Renviron \
    && cat ~/.Renviron

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libgmp3-dev \
    libgtk-3-dev \
    libgtkmm-3.0-dev \
    libssl-dev \
    libxt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python
RUN pip install --no-cache-dir -U pip
RUN conda update conda
RUN conda install -y -c bioconda scanpy kallisto \
    && conda install -y louvain leidenalg \
    && conda install -y -c statiskit libboost \
    && pip install --no-cache-dir -U Cython
RUN pip install --no-cache-dir llvmlite --ignore-installed
RUN pip install --no-cache-dir -U velocyto scvelo numba pybind11 macs2

# cellphoneDB
RUN python -m venv cpdb-venv \
    && . cpdb-venv/bin/activate \
    && pip install --no-cache-dir cellphonedb scikit-learn==0.20.4
ENV PATH $PATH:/opt/cpdb-venv/bin/

# SCCAF
RUN python -m venv sccaf-venv \
    && . sccaf-venv/bin/activate \
    && pip install --no-cache-dir sccaf
ENV PATH $PATH:/opt/sccaf-venv/bin/

# pySCENIC
RUN python -m venv pyscenic-venv \
    && . pyscenic-venv/bin/activate \
    && pip install --no-cache-dir pyscenic
ENV PATH $PATH:/opt/pyscenic-venv/bin/

# Scrublet
RUN pip install --no-cache-dir scrublet

# scVI
RUN conda install scvi-tools -c bioconda -c conda-forge \
    && pip install --no-cache-dir scikit-misc plotnine

# Palantir, MAGIC
RUN pip install --no-cache-dir PhenoGraph palantir rpy2 magic-impute \
    && R -e "install.packages('gam')"

# Theis_Tutorial
RUN pip install --no-cache-dir gprofiler-official anndata2ri bbknn \
	&& R -e "BiocManager::install(c('MAST','clusterExperiment'))"

# Seurat
RUN R -e "install.packages(c('sleepwalk','bit64','zoo','scBio','Seurat','metap'), repos='https://cran.ism.ac.jp/')"

# R for jupyterbook
RUN R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))" \
    && R -e "devtools::install_github('IRkernel/IRkernel')" \
    && R -e "IRkernel::installspec()"

RUN R -e "BiocManager::install(c('limma','scater','pcaMethods','WGCNA','preprocessCore', 'RCA', 'scmap', 'mixtools', 'stringi', 'rbokeh', 'DT', 'NMF', 'pheatmap', 'R2HTML', 'doMC', 'doRNG', 'scran', 'slingshot','DropletUtils', 'monocle', 'scTensor'))"
RUN R -e "options(timeout=6000); BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Mmusculus.UCSC.mm10', 'BSgenome.Scerevisiae.UCSC.sacCer3', 'BSgenome.Dmelanogaster.UCSC.dm6'))"
RUN R -e "devtools::install_github(c('jokergoo/ComplexHeatmap'))"

# Seurat wrappers
RUN R -e "BiocManager::install(c('CoGAPS'))"
RUN R -e "BiocManager::install(c('scry'))"
RUN R -e "install.packages('glmpca')"
RUN R -e "devtools::install_github('kharchenkolab/conos')"
RUN R -e "devtools::install_github('satijalab/seurat', ref = 'mixscape')"
RUN R -e "devtools::install_github('satijalab/seurat-wrappers')"

# SeuratData
RUN R -e "devtools::install_github('satijalab/seurat-data')"
#RUN R -e "options(timeout=6000); SeuratData::InstallData(c('pbmcsca','ifnb','panc8','pbmc3k'))"

COPY SeuratData/ifnb.SeuratData_3.1.0.tar.gz ifnb.SeuratData_3.1.0.tar.gz
COPY SeuratData/panc8.SeuratData_3.0.2.tar.gz panc8.SeuratData_3.0.2.tar.gz
COPY SeuratData/pbmcsca.SeuratData_3.0.0.tar.gz pbmcsca.SeuratData_3.0.0.tar.gz
COPY SeuratData/pbmc3k.SeuratData_3.0.0.tar.gz pbmc3k.SeuratData_3.0.0.tar.gz
RUN R -e "install.packages('ifnb.SeuratData_3.1.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('panc8.SeuratData_3.0.2.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('pbmcsca.SeuratData_3.0.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('pbmc3k.SeuratData_3.0.0.tar.gz', repos = NULL, type = 'source')"
RUN rm ifnb.SeuratData_3.1.0.tar.gz panc8.SeuratData_3.0.2.tar.gz pbmcsca.SeuratData_3.0.0.tar.gz pbmc3k.SeuratData_3.0.0.tar.gz

# Signac
RUN R -e "BiocManager::install('ggbio')"
RUN R -e "install.packages('Signac')" \
    && R -e "BiocManager::install(c('EnsDb.Hsapiens.v75','EnsDb.Hsapiens.v79', 'EnsDb.Hsapiens.v86', 'EnsDb.Mmusculus.v79'))"

# SingleR
RUN R -e "BiocManager::install(c('SingleR','scRNAseq','celldex'))"

# scImpute
RUN R -e "devtools::install_github(c('Vivianstats/scImpute'))"
# singleCellHaystack
RUN R -e "devtools::install_github(c('alexisvdb/singleCellHaystack'))"
# velocyto.R
RUN R -e "devtools::install_github(c('aertslab/SCopeLoomR', 'velocyto-team/velocyto.R'))"

# scCATCH
RUN R -e "devtools::install_github('ZJUFanLab/scCATCH')"

# SingleCellNet
RUN R -e "devtools::install_github(c('pcahan1/singleCellNet'))"
RUN R -e "devtools::install_github('mojaveazure/loomR', ref = 'develop')"

# Splatter
RUN R -e "BiocManager::install('splatter')"

# SCRABBLE
RUN R -e "devtools::install_github('software-github/SCRABBLE/R')"

# Imputation comparison
RUN R -e "install.packages(c('SAVER','ClusterR'))"

# SingleCellSingnalR
RUN R -e "devtools::install_github('SCA-IRCM/SingleCellSignalR_v1', subdir = 'SingleCellSignalR')"

# ArchR
RUN R -e "devtools::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())"
# chromVAR
RUN R -e "BiocManager::install(c('chromVAR'))" \
    && R -e "devtools::install_github(c('GreenleafLab/chromVARmotifs','GreenleafLab/motifmatchr'))"
# FlyATACAtlus
RUN R -e "install.packages(c('irlba','DDRTree','densityClust'))"

# Monocle3
RUN R -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment', 'batchelor'))"
RUN R -e "devtools::install_github('cole-trapnell-lab/leidenbase')" \
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

# DoubletFinder
RUN R -e "devtools::install_github('chris-mcginnis-ucsf/DoubletFinder')"

# LIGER (FFTW, FIt-SNE)
#RUN wget http://www.fftw.org/fftw-3.3.8.tar.gz \
#    && tar zxvf fftw-3.3.8.tar.gz \
#    && rm fftw-3.3.8.tar.gz \
#    && cd fftw-3.3.8 \
#    && ./configure \
#    && make \
#    && make install \
#    && git clone https://github.com/KlugerLab/FIt-SNE.git \
#    && cd FIt-SNE/ \
#    && g++ -std=c++11 -O3  src/sptree.cpp src/tsne.cpp src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm \
#    && cp bin/fast_tsne /usr/local/bin/
#RUN R -e "devtools::install_github(c('MacoskoLab/liger'))"
#ADD bedops_linux_x86_64-v2.4.39 bedops_linux_x86_64-v2.4.39
#ENV PATH ${PATH}:/opt/bedops_linux_x86_64-v2.4.39

# Harmony
RUN R -e "install.packages('gganimate')" \
    && R -e "BiocManager::install(c('sva','DESeq2'))" \
    && R -e "devtools::install_github(c('immunogenomics/harmony','immunogenomics/presto','JEFworks/MUDAN'))"
RUN pip install --no-cache-dir harmonypy

# scAI
RUN R -e "devtools::install_github('sqjin/scAI')"

# CellAssign
RUN R -e "install.packages(c('here'))"
#RUN R -e "tensorflow::install_tensorflow(extra_packages='tensorflow-probability', version = '2.1.0')" \
RUN    R -e "tensorflow::tf_config()"
RUN R -e "devtools::install_github('Irrationone/cellassign')"

# scGen
RUN python -m venv scgen-venv \
    && . scgen-venv/bin/activate \
    && pip install --no-cache-dir scgen
ENV PATH $PATH:/opt/scgen-venv/bin/

# metacells
RUN R -e "BiocManager::install('tanaylab/metacell')"

# motif database
RUN R -e "BiocManager::install(c('JASPAR2016','JASPAR2018','JASPAR2020'))"

# cisTopic
RUN R -e "devtools::install_github('aertslab/cisTopic')"

# SeuratDisk
RUN R -e "devtools::install_github('mojaveazure/seurat-disk')"

# LIGER (FFTW, FIt-SNE)
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
RUN R -e "devtools::install_github(c('MacoskoLab/liger'))"
ADD bedops_linux_x86_64-v2.4.39 bedops_linux_x86_64-v2.4.39
ENV PATH ${PATH}:/opt/bedops_linux_x86_64-v2.4.39

RUN chmod 777 jupyternotebook.sh rserver.sh
RUN rm ~/.Renviron

# DoubletDetection
RUN pip install --no-cache-dir doubletdetection

RUN apt-get update \
     && apt-get install -y --no-install-recommends \
     libgraphviz-dev \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Constclust
RUN pip install --no-cache-dir constclust
