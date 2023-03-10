FROM --platform=linux/amd64 ubuntu:20.04

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
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ffmpeg libsm6 libxext6 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb-dev libxkbcommon-x11-0 \
    libpulse-mainloop-glib0 ubuntu-restricted-extras libqt5multimedia5-plugins vlc && rm -rf /var/lib/apt/lists/*;

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

# TODO: REFACTOR CODE SO IT'S POSSIBLE TO RUN GUI WITHOUT TORCH
RUN conda install pytorch cpuonly -c pytorch
RUN pip install --no-cache-dir "chardet<4.0" h5py matplotlib numpy omegaconf >=2 "pandas<1.4" PySide2 \
    "scikit-learn<1.1" "scipy<1.8" tqdm opencv-python-headless vidio >=0.0.4 pytest \
    opencv-transforms

# # needed for pandas for some reason
ADD . /app/deepethogram
WORKDIR /app/deepethogram
ENV DEG_VERSION='gui'
RUN pip install --no-cache-dir -e . --no-dependencies