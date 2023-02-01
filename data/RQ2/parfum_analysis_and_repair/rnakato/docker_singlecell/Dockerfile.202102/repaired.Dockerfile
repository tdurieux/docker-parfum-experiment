# Single-cell analysis pipeline for "Integrated analysis and regulation of cellular diversity"

FROM rnakato/r_python_gpu:2020.12
LABEL maintainer "Ryuichiro Nakato <rnakato@iqb.u-tokyo.ac.jp>"

USER root
WORKDIR /opt

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib/

ARG GITHUB_PAT
RUN set -x && \
    echo "GITHUB_PAT=$GITHUB_PAT" > ~/.Renviron \
    && cat ~/.Renviron \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libgfortran5 \
    libgmp3-dev \
    libgraphviz-dev \
    libgtk-3-dev \
    libgtkmm-3.0-dev \
    libssl-dev \
    libunwind-dev \
    libxt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
# Python \
    && pip install --no-cache-dir -U pip \
    && pip uninstall -y tensorflow tensorflow-gpu \
    && conda update conda \
    && conda install -y -c bioconda scanpy kallisto \
    && conda install -y louvain leidenalg \
    && conda install -y -c statiskit libboost \
    && conda install -y cython python-igraph \
    && pip install --no-cache-dir llvmlite --ignore-installed \
    && pip install --no-cache-dir -U velocyto scvelo numba pybind11 macs2 \
# scPopcorn
#    && pip install scpopcorn \
# Harmonypy, Scrublet, DoubletDetection, Constclust, monet, EpiScanpy
    && pip install --no-cache-dir harmonypy scrublet doubletdetection constclust monet episcanpy \
# scVI
    && python -m venv scvi-venv \
    && . scvi-venv/bin/activate \
    && pip install --no-cache-dir scikit-misc plotnine scvi-tools \
    && deactivate \
# Palantir, MAGIC
    && pip install --no-cache-dir PhenoGraph palantir rpy2 magic-impute \
    && R -e "install.packages('gam')" \
# Theis_Tutorial
    && pip install --no-cache-dir gprofiler-official anndata2ri bbknn \
    && R -e "BiocManager::install(c('MAST','clusterExperiment'))" \
# CellRank
    && conda install -y -c conda-forge -c bioconda cellrank-krylov \
# cellphoneDB
    && python -m venv cpdb-venv \
    && . cpdb-venv/bin/activate \
    && pip install --no-cache-dir cellphonedb scikit-learn==0.22 \
    && deactivate \
# SCCAF
    && python -m venv sccaf-venv \
    && . sccaf-venv/bin/activate \
    && pip install --no-cache-dir sccaf \
    && deactivate \
# pySCENIC
    && python -m venv pyscenic-venv \
    && . pyscenic-venv/bin/activate \
    && pip install --no-cache-dir pyscenic \
    && deactivate \
# scGen
    && python -m venv scgen-venv \
    && . scgen-venv/bin/activate \
    && pip install --no-cache-dir scgen \
    && deactivate \
# cell2cell
    && conda create -n cell2cell -y python=3.7.8 jupyter numpy scipy matplotlib pandas seaborn \
    && conda init bash \
    && . ~/.bashrc \
    && conda activate cell2cell \
    && pip install --no-cache-dir 'cell2cell==0.2.2' \
    && pip install --no-cache-dir git+https://github.com/BubaVV/Pyevolve \
    && pip install --no-cache-dir obonet umap-learn \
    && conda deactivate \
# SAVER-X
    && python -m venv saverx-venv \
    && . saverx-venv/bin/activate \
    && pip install --no-cache-dir sctransfer \
    && R -e "remotes::install_github('jingshuw/SAVERX')" \
    && pip install --no-cache-dir obonet umap-learn \
    && deactivate \
# LIGER (FFTW, FIt-SNE)
    && wget https://www.fftw.org/fftw-3.3.8.tar.gz \
    && tar zxvf fftw-3.3.8.tar.gz \
    && rm fftw-3.3.8.tar.gz \
    && cd fftw-3.3.8 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && git clone https://github.com/KlugerLab/FIt-SNE.git \
    && cd FIt-SNE/ \
    && g++ -std=c++11 -O3  src/sptree.cpp src/tsne.cpp src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm \
    && cp bin/fast_tsne /usr/local/bin/ \
    && cd \
    && rm -rf ~/fftw-3.3.8 \
    && R -e "remotes::install_github(c('MacoskoLab/liger'))" \
    && conda clean -i -t -y

# Seurat
COPY SeuratData/ifnb.SeuratData_3.1.0.tar.gz ifnb.SeuratData_3.1.0.tar.gz
COPY SeuratData/panc8.SeuratData_3.0.2.tar.gz panc8.SeuratData_3.0.2.tar.gz
COPY SeuratData/pbmcsca.SeuratData_3.0.0.tar.gz pbmcsca.SeuratData_3.0.0.tar.gz
COPY SeuratData/pbmc3k.SeuratData_3.0.0.tar.gz pbmc3k.SeuratData_3.0.0.tar.gz

# R for jupyterbook
RUN R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))" \
    && R -e "remotes::install_github('IRkernel/IRkernel')" \
    && R -e "IRkernel::installspec()" \
# Seurat
    && R -e "install.packages(c('sleepwalk','bit64','here','zoo','scBio','Seurat','metap'))" \
# DelayedMatrixStats
    && R -e "devtools::install_github('PeteHaitch/DelayedMatrixStats@RELEASE_3_12')" \
# others
    && R -e "BiocManager::install(c('limma','scater','pcaMethods','WGCNA','preprocessCore', 'RCA', 'scmap', 'mixtools', 'stringi', 'rbokeh', 'DT', 'NMF', 'pheatmap', 'R2HTML', 'doMC', 'doRNG', 'scran', 'slingshot','DropletUtils', 'monocle', 'MeSH.Hsa.eg.db', 'scTensor'))" \
    && R -e "options(timeout=6000); BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Mmusculus.UCSC.mm10', 'BSgenome.Scerevisiae.UCSC.sacCer3', 'BSgenome.Dmelanogaster.UCSC.dm6'))" \
    && R -e "remotes::install_github(c('jokergoo/ComplexHeatmap'))" \
# Seurat wrappers
    && R -e "BiocManager::install(c('CoGAPS'))" \
    && R -e "BiocManager::install(c('scry'))" \
    && R -e "install.packages('glmpca')" \
    && R -e "remotes::install_github('kharchenkolab/conos')" \
#    && R -e "remotes::install_github('satijalab/seurat', ref = 'mixscape')" \
    && R -e "remotes::install_github('satijalab/seurat-wrappers')" \
# SeuratData
    && R -e "remotes::install_github('satijalab/seurat-data')" \
#RUN R -e "options(timeout=6000); SeuratData::InstallData(c('pbmcsca','ifnb','panc8','pbmc3k'))"
    && R -e "install.packages('ifnb.SeuratData_3.1.0.tar.gz', repos = NULL, type = 'source')" \
    && R -e "install.packages('panc8.SeuratData_3.0.2.tar.gz', repos = NULL, type = 'source')" \
    && R -e "install.packages('pbmcsca.SeuratData_3.0.0.tar.gz', repos = NULL, type = 'source')" \
    && R -e "install.packages('pbmc3k.SeuratData_3.0.0.tar.gz', repos = NULL, type = 'source')" \
    && rm ifnb.SeuratData_3.1.0.tar.gz panc8.SeuratData_3.0.2.tar.gz pbmcsca.SeuratData_3.0.0.tar.gz pbmc3k.SeuratData_3.0.0.tar.gz \
# SeuratDisk
    && R -e "remotes::install_github('mojaveazure/seurat-disk')" \
# Signac
    && R -e "BiocManager::install('ggbio')" \
    && R -e "install.packages('Signac')" \
    && R -e "BiocManager::install(c('EnsDb.Hsapiens.v75','EnsDb.Hsapiens.v79', 'EnsDb.Hsapiens.v86', 'EnsDb.Mmusculus.v79'))" \
# SingleR
    && R -e "BiocManager::install(c('SingleR','scRNAseq','celldex'))" \
# scImpute, singleCellHaystack, scCATCH
    && R -e "remotes::install_github(c('Vivianstats/scImpute', 'alexisvdb/singleCellHaystack', 'ZJUFanLab/scCATCH'))" \
# velocyto.R
    && R -e "remotes::install_github(c('aertslab/SCopeLoomR', 'velocyto-team/velocyto.R'))" \
# SingleCellNet
    && R -e "remotes::install_github(c('pcahan1/singleCellNet'))" \
    && R -e "remotes::install_github('mojaveazure/loomR', ref = 'develop')" \
# Splatter, SC3
    && R -e "BiocManager::install(c('splatter','SC3'))" \
# SCRABBLE
    && R -e "remotes::install_github('software-github/SCRABBLE/R')" \
# Imputation comparison
    && R -e "install.packages(c('SAVER','ClusterR'))" \
# SingleCellSingnalR
    && R -e "BiocManager::install(c('SingleCellSignalR'))" \
# ArchR
    && R -e "devtools::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())" \
# chromVAR
    && R -e "BiocManager::install(c('chromVAR'))" \
    && R -e "remotes::install_github(c('GreenleafLab/chromVARmotifs','GreenleafLab/motifmatchr'))" \
# FlyATACAtlus
    && R -e "install.packages(c('irlba','DDRTree','densityClust'))" \
# Monocle3
    && R -e "BiocManager::install(c('BiocGenerics', 'limma', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment', 'batchelor', 'Matrix.utils'))" \
    && R -e "remotes::install_github('cole-trapnell-lab/leidenbase')" \
    && R -e "remotes::install_github('cole-trapnell-lab/monocle3', ref='develop')" \
    && R -e "BiocManager::install(c('org.Mm.eg.db', 'org.Hs.eg.db', 'org.Dm.eg.db', 'org.Ce.eg.db'))" \
    && R -e "remotes::install_github('cole-trapnell-lab/garnett', ref='monocle3')" \
# cicero
    && R -e "remotes::install_github('cole-trapnell-lab/cicero-release', ref = 'monocle3')" \
# kallisto, bustools
    && git clone https://github.com/BUStools/bustools.git \
    && cd bustools \
    && mkdir build \
    && cd build \
    && cmake .. && make && make install \
    && R -e "remotes::install_github(c('tidymodels/tidymodels','BUStools/BUSpaRse'))" \
    && rm -rf /opt/bustools \
    && cd \
# DoubletFinder
    && R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')" \
# Harmony
    && R -e "install.packages('gganimate')" \
    && R -e "BiocManager::install(c('sva','DESeq2'))" \
    && R -e "remotes::install_github(c('immunogenomics/harmony','immunogenomics/presto','JEFworks/MUDAN'))" \
# CellAssign
    && python -m venv cellassign-venv \
    && . cellassign-venv/bin/activate \
    && pip install --no-cache-dir tensorflow==2.1.0 tensorflow_gpu==2.1.0 \
    && R -e "tensorflow::install_tensorflow(extra_packages='tensorflow-probability', version = '2.1.0')" \
    && R -e "tensorflow::tf_config()" \
    && R -e "remotes::install_github('Irrationone/cellassign')" \
    && deactivate \
# metacells
    && R -e "BiocManager::install('tanaylab/metacell')" \
# motif database
    && R -e "BiocManager::install(c('JASPAR2016','JASPAR2018','JASPAR2020'))" \
# cisTopic, scAI
    && R -e "remotes::install_github(c('aertslab/cisTopic', 'sqjin/scAI'))" \
# SCDC, MuSiC
    && R -e "remotes::install_github(c('renozao/xbioc','meichendong/SCDC', 'xuranw/MuSiC'))" \
# MOFA2
    && R -e "remotes::install_github('bioFAM/MOFA2', build_opts = c('--no-resave-data --no-build-vignettes'))" \
# FROWMAP
    && R -e "install.packages('SDMTools',,'http://rforge.net/',type='source')" \
    && R -e "install.packages(c('igraph','robustbase','shiny','tcltk','rhandsontable'))" \
    && R -e "BiocManager::install('flowCore')" \
    && R -e "remotes::install_github(c('nolanlab/scaffold','nolanlab/Rclusterpp','nolanlab/spade','zunderlab/FLOWMAP'))" \
# bigSCale2
    && R -e "install.packages(c('fmsb','ClassDiscovery','ggalt','ggdendro','ggpubr'))" \
    && R -e "BiocManager::install(c('org.Mm.eg.db', 'org.Hs.eg.db', 'BioQC', 'SingleCellExperiment'))" \
    && R -e "options(timeout=6000); remotes::install_github('iaconogi/bigSCale2')"

COPY bedops_linux_x86_64-v2.4.39 bedops_linux_x86_64-v2.4.39
COPY cell2cell_jupyter.sh cell2cell_jupyter.sh
ENV PATH $PATH:/opt/bedops_linux_x86_64-v2.4.39 $PATH:/opt/sccaf-venv/bin/ $PATH:/opt/cpdb-venv/bin/ $PATH:/opt/pyscenic-venv/bin/ $PATH:/opt/scgen-venv/bin/

RUN chmod 777 jupyternotebook.sh rserver.sh cell2cell_jupyter.sh
RUN rm ~/.Renviron
