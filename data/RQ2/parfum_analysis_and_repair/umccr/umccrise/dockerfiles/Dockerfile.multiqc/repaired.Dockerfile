FROM ubuntu:16.04
MAINTAINER Vlad Saveliev "https://github.com/vladsaveliev"

# Setup a base system
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl wget git unzip tar gzip bzip2 g++ make zlib1g-dev nano && rm -rf /var/lib/apt/lists/*;

# Install fonts for pandoc/rmarkdown
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install --no-install-recommends -y ttf-mscorefonts-installer && rm -rf /var/lib/apt/lists/*;

# Setting locales and timezones, based on https://github.com/jacksoncage/node-docker/blob/master/Dockerfile
# (setting UTC for readr expecting UTC https://rdrr.io/github/tidyverse/readr/src/R/locale.R)
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y locales language-pack-en && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get install --no-install-recommends -y tzdata && \
    echo "Etc/UTC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;

# Install conda
RUN wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && bash miniconda.sh -b -p /miniconda
ENV PATH /miniconda/bin:$PATH

# Install conda environments
RUN conda create -n myenv -c bioconda illumina-interop multiqc
ENV PATH /miniconda/envs/myenv/bin:$PATH
ENV CONDA_PREFIX /miniconda/envs/myenv

# Add the MultiQC source files to the container
ADD . /usr/src/multiqc
WORKDIR /usr/src/multiqc

# Install MultiQC
RUN python setup.py install

RUN echo "bcl2fastq: genome_size: 3200000000" >> $HOME/.multiqc_config.yaml
