FROM continuumio/miniconda3:4.5.11

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libz-dev libcurl3-dev && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL "C"
ENV PATH "$PATH:/opt/conda/bin"
ENV KIPOI_ENV_DB_PATH "/kipoi/envs.json"

RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    pip install --no-cache-dir git+https://github.com/kipoi/kipoi
    # install kipoi from the master branch for now

# Create all the environments
RUN mkdir -p /kipoi && \
    kipoi ls && \
    kipoi env create all

RUN touch /kipoi/envs.json && chmod go+r /kipoi/envs.json

# clean packages
RUN conda clean --index-cache --tarballs --packages --yes
