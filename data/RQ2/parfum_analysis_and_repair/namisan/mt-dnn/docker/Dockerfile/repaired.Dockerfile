# Base image must at least have pytorch and CUDA installed.
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:20.10-py3
FROM $BASE_IMAGE
ARG BASE_IMAGE
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "Installing Apex on top of ${BASE_IMAGE}"
RUN apt-get update && apt-get install --no-install-recommends -y \
sudo \
make \
vim \
jq \
locate \
wget \
tar \
bzip2 \
sudo \
environment-modules \
libhwloc-dev \
hwloc \
libhwloc-common \
libhwloc-plugins \
openssh-server \
binutils \
tcl \
curl \
ipmitool \
rename \
libibverbs-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tensorboard_logger
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir h5py==2.7.1
RUN pip install --no-cache-dir -U scikit-learn
RUN pip install --no-cache-dir nltk >=3.4
RUN pip install --no-cache-dir sentencepiece
RUN python -m nltk.downloader punkt
RUN pip install --no-cache-dir numpy >=1.15.4
RUN pip install --no-cache-dir pandas >=0.24.0
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir colorlog
RUN pip install --no-cache-dir regex
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir tb-nightly
RUN pip install --no-cache-dir seqeval==0.0.12
RUN pip install --no-cache-dir transformers==4.6.0
RUN pip install --no-cache-dir tensorboardX
RUN pip install --no-cache-dir pytorch-pretrained-bert==v0.6.0
RUN pip install --no-cache-dir more_itertools
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pwd
WORKDIR /workspace
