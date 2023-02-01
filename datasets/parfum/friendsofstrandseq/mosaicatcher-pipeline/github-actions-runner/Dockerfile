FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="daf01a5306b6104115b7568d75e257ab367dfe9d967c2eace08ae80ba73c601c"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/mc_base.yaml
#   prefix: /conda-envs/cd15c940fe1181e1751e02b25c7fcfb7
#   name: mc-base
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - pandas
#     - pysam
#     - tqdm
#     - perl
#     - pypdf2
#     - parmap
RUN mkdir -p /conda-envs/cd15c940fe1181e1751e02b25c7fcfb7
COPY workflow/envs/mc_base.yaml /conda-envs/cd15c940fe1181e1751e02b25c7fcfb7/environment.yaml

# Conda environment:
#   source: workflow/envs/mc_bioinfo_tools.yaml
#   prefix: /conda-envs/491a340c3c20c63397962b44091da5b0
#   name: mc-bioinfo-tools
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - samtools
#     - bcftools
#     - tabix
#     - freebayes
#     - bcftools
#     - whatshap
RUN mkdir -p /conda-envs/491a340c3c20c63397962b44091da5b0
COPY workflow/envs/mc_bioinfo_tools.yaml /conda-envs/491a340c3c20c63397962b44091da5b0/environment.yaml

# Conda environment:
#   source: workflow/envs/rtools.yaml
#   prefix: /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d
#   name: rtools
#   channels:
#     - conda-forge
#     - bioconda
#     - r
#     - anaconda
#   dependencies:
#     - bioconductor-biocparallel=1.16.6
#     - bioconductor-bsgenome
#     - bioconductor-bsgenome.hsapiens.ucsc.hg19
#     - bioconductor-bsgenome.hsapiens.ucsc.hg38=1.4.1
#     - bioconductor-fastseg=1.28.0
#     - bioconductor-genomicalignments=1.18.1
#     - bioconductor-genomicranges=1.34.0
#     - bioconductor-rsamtools=1.34.0
#     - bioconductor-s4vectors=0.20.1
#     - r-assertthat=0.2.1
#     - r-base=3.5.1
#     - r-biocmanager
#     - r-cowplot=1.0.0
#     - r-data.table=1.12.6
#     - r-devtools=2.2.2
#     - r-doparallel
#     - r-foreach
#     - r-ggplot2=3.3.0
#     - r-gtools=3.8.1
#     - r-reshape2=1.4.3
#     - r-scales=1.1.0
#     - r-zoo=1.8_3
#     - r-dplyr=0.8.5
#     - r-mc2d=0.1_18
#     - r-pheatmap=1.0.12
#     - bioconductor-complexheatmap=2.0.0
#     - r-gplots=3.0.3
#     - r-scales=1.1.0
#     - r-rcolorbrewer=1.1_2
#     - r-stringr=1.4.0
#     - fonts-anaconda
RUN mkdir -p /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d
COPY workflow/envs/rtools.yaml /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/cd15c940fe1181e1751e02b25c7fcfb7 --file /conda-envs/cd15c940fe1181e1751e02b25c7fcfb7/environment.yaml && \
    mamba env create --prefix /conda-envs/491a340c3c20c63397962b44091da5b0 --file /conda-envs/491a340c3c20c63397962b44091da5b0/environment.yaml && \
    mamba env create --prefix /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d --file /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d/environment.yaml && \
    mamba clean --all -y

# ----------------
# CUSTOM PART 
# TAG 1.3
# ----------------
# ----------------

RUN mamba install -c conda-forge -c bioconda samtools && \
    chmod -R 0777 /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d/lib/R/library && \
    pwd && \
    apt-get install git && \
    git clone -b smk_workflow_catalog https://github.com/friendsofstrandseq/mosaicatcher-pipeline.git /mosaicatcher-pipeline && \
    /conda-envs/c1d3853dcbbee9cb7d9268e5a19af03d/bin/Rscript /mosaicatcher-pipeline/workflow/scripts/strandphaser_scripts/install_strandphaser.R 69c9fb4 https://github.com/daewoooo/StrandPhaseR

