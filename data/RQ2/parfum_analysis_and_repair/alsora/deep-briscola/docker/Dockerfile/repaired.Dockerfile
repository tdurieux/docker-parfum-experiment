# @author Alberto Soragna (alberto dot soragna at gmail dot com)
# @2018

FROM ubuntu:16.04
LABEL maintainer="alberto dot soragna at gmail dot com"

# working directory
ENV HOME /root
WORKDIR $HOME

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


# general utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    curl \
    git \
    vim \
    nano \
    python-dev \
    python3-pip \
    ipython && rm -rf /var/lib/apt/lists/*;

# pip upgrade
RUN pip3 install --no-cache-dir --upgrade pip


#### TENSORFLOW SETUP


# install tensorflow
RUN pip install --no-cache-dir tensorflow


#### ADDITIONAL PYTHON PACKAGES


RUN pip install --no-cache-dir \
    hyperopt \
    matplotlib \
    pandas

RUN apt-get install --no-install-recommends -y \
    python3-tk \
    libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;


#### SET ENVIRONMENT


RUN echo ' \n\
alias python="python3"' >> $HOME/.bashrc




