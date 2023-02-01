FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

WORKDIR /tmp

# Generic python installations
# PyTorch Audio for DeepSpeech: https://github.com/SeanNaren/deepspeech.pytorch/releases
# Development environment installations
RUN apt-get update && apt-get install --no-install-recommends -y \
  python \
  python-pip \
  sox \
  libsox-dev \
  libsox-fmt-all \
  git \
  cmake \
  tree \
  htop \
  bmon \
  iotop \
  tmux \
  vim \
  apt-utils && rm -rf /var/lib/apt/lists/*;

# Make pip happy about itself.
RUN pip install --no-cache-dir --upgrade pip

# Unlike apt-get, upgrading pip does not change which package gets installed,
# (since it checks pypi everytime regardless) so it's okay to cache pip.
# Install pytorch
# http://pytorch.org/
RUN pip install --no-cache-dir h5py \
                hickle \
                matplotlib \
                tqdm \
                http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp27-cp27mu-manylinux1_x86_64.whl \
                torchvision \
                cffi \
                python-Levenshtein \
                librosa \
                wget \
                tensorboardX

RUN apt-get update && apt-get install --yes --no-install-recommends cmake \
                                                                    sudo && rm -rf /var/lib/apt/lists/*;

ENV CUDA_HOME "/usr/local/cuda"

# install warp-ctc
RUN git clone https://github.com/SeanNaren/warp-ctc.git && \
    cd warp-ctc && \
    mkdir -p build && cd build && cmake .. && make && \
    cd ../pytorch_binding && python setup.py install

# install pytorch audio
RUN apt-get install --no-install-recommends -y sox libsox-dev libsox-fmt-all && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/pytorch/audio.git
RUN cd audio; python setup.py install

# install ctcdecode
RUN git clone --recursive https://github.com/parlance/ctcdecode.git
RUN cd ctcdecode; pip install --no-cache-dir .

ENV SHELL /bin/bash
