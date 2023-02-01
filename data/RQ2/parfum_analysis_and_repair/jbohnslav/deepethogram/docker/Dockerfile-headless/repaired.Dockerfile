FROM --platform=linux/amd64 nvidia/cuda:11.3.0-cudnn8-runtime-ubuntu20.04

# modified from here
# https://github.com/anibali/docker-pytorch/blob/master/dockerfiles/1.10.0-cuda11.3-ubuntu20.04/Dockerfile
# Install some basic utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# don't ask for location etc user input when building
# this is for opencv, apparently
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ffmpeg && rm -rf /var/lib/apt/lists/*;

# Create a working directory and data directory
RUN mkdir /app
WORKDIR /app

# Set up the Conda environment
ENV CONDA_AUTO_UPDATE_CONDA=false \
    PATH=/opt/miniconda/bin:$PATH

# install miniconda
RUN curl -f -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/miniconda \
    && rm ~/miniconda.sh \
    && conda update conda

# install
RUN conda install python=3.7 -y
RUN pip install --no-cache-dir setuptools --upgrade && pip install --no-cache-dir --upgrade pip
RUN conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch

# RUN pip install  \
#         vidio

RUN pip install --no-cache-dir "chardet<4.0" h5py kornia >=0.5 matplotlib numpy omegaconf >=2 "pandas<1.4" \
    "scikit-learn<1.1" "scipy<1.8" tqdm pytorch_lightning >=1.5.10 opencv-python-headless vidio >=0.0.4 pytest \
    opencv-transforms

# # needed for pandas for some reason
ADD . /app/deepethogram
WORKDIR /app/deepethogram
ENV DEG_VERSION='headless'
RUN pip install --no-cache-dir -e . --no-dependencies