FROM jupyter/scipy-notebook

USER root

# Get connectome-workbench
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl gnupg gnupg1 gnupg2 python3-pip && rm -rf /var/lib/apt/lists/*;

# Set up Bioconda
RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda install -c bioconda/label/cf201901 connectome-workbench

# Get ciftify
RUN apt-get update && \
    apt-get install --no-install-recommends -y git-annex && \
    pip install --no-cache-dir ciftify datalad && rm -rf /var/lib/apt/lists/*;

CMD ["jupyter lab"]
