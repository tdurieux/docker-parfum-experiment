##########################
# Last updated at 2017-11-24 15:06:50.175919 -0800 PST
FROM ubuntu:17.10
##########################

##########################
# Set working directory
ENV ROOT_DIR /
WORKDIR ${ROOT_DIR}
ENV HOME /root
##########################

##########################
# Update OS
# Configure 'bash' for 'source' commands
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get -y update \
  && apt-get -y install \
  build-essential \
  gcc \
  apt-utils \
  pkg-config \
  software-properties-common \
  apt-transport-https \
  sudo \
  bash \
  tar \
  unzip \
  curl \
  wget \
  python \
  python-pip \
  python-dev \
  r-base \
  fonts-dejavu \
  gfortran \
  && rm /bin/sh \
  && ln -s /bin/bash /bin/sh \
  && ls -l $(which bash) \
  && echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y dist-upgrade \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y autoremove \
  && apt-get -y autoclean
##########################

##########################
# install iPython notebook
RUN pip --no-cache-dir install \
  ipykernel \
  jupyter \
  && python -m ipykernel.kernelspec
##########################

##########################
# install R
RUN wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O /root/miniconda.sh \
  && bash /root/miniconda.sh -b -p /root/miniconda

# do not overwrite default '/usr/bin/python'
ENV PATH ${PATH}:/root/miniconda/bin

# https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile
RUN conda update conda \
  && conda create --yes --name r \
  python=2.7 \
  ipykernel \
  r \
  r-essentials \
  'r-base=3.3.2' \
  'r-irkernel=0.7*' \
  'r-plyr=1.8*' \
  'r-devtools=1.12*' \
  'r-tidyverse=1.0*' \
  'r-shiny=0.14*' \
  'r-rmarkdown=1.2*' \
  'r-forecast=7.3*' \
  'r-rsqlite=1.1*' \
  'r-reshape2=1.4*' \
  'r-nycflights13=0.2*' \
  'r-caret=6.0*' \
  'r-rcurl=1.95*' \
  'r-crayon=1.3*' \
  'r-randomforest=4.6*' \
  && conda clean -tipsy \
  && conda list \
  && source activate r
##########################

##########################
# Configure Jupyter
ADD ./jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
ADD ./run_jupyter.sh /
##########################

