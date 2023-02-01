FROM nvidia/cuda:10.0-cudnn7-devel
MAINTAINER Tom Kocmi <kocmi@ufal.mff.cuni.cz>

# Install git, wget, python-dev, pip and other dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  wget \
  cmake \
  vim \
  nano \
  python3 \
  libopenblas-dev \
  python3-dev \
  python3-pip \
  python3-nose \
  python3-numpy \
  python3-scipy \
  python3-pygraphviz \
  xml-twig-tools && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir tensorflow==1.15

# Set CUDA_ROOT
ENV CUDA_ROOT /usr/local/cuda/bin


RUN mkdir -p /path/to
WORKDIR /path/to/

# Install mosesdecoder
RUN git clone https://github.com/moses-smt/mosesdecoder

# Install subwords
RUN git clone https://github.com/rsennrich/subword-nmt

# Install nematus
COPY . /path/to/nematus
WORKDIR /path/to/nematus
RUN python3 setup.py install

WORKDIR /

# playground will contain user defined scripts, it should be run as:
# nvidia-docker run -v `pwd`:/playground -it nematus-docker
RUN mkdir playground
WORKDIR /playground
