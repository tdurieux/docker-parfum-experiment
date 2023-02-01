#
# Facebook FAIR SentEval
# A python tool for evaluating the quality of sentence embeddings.
#
# @see https://github.com/facebookresearch/SentEval
#

FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Loreto Parisi <loretoparisi@gmail.com>

# Install base packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  software-properties-common \
  python-dev \
  python-pip \
  cabextract \
  sudo && rm -rf /var/lib/apt/lists/*;

# install dependencies
RUN pip install --no-cache-dir numpy scipy scikit-learn sklearn

WORKDIR /root/

# SentEval
RUN git clone https://github.com/facebookresearch/SentEval.git

# download dataset and models
RUN \
    cd SentEval/data && \
    ./get_transfer_data.bash && \
    cd .. && \
    curl -f -Lo examples/infersent.allnli.pickle https://s3.amazonaws.com/senteval/infersent/infersent.allnli.pickle && \
    curl -f -Lo examples/infersent.snli.pickle https://s3.amazonaws.com/senteval/infersent/infersent.snli.pickle && \
    cd examples/ && \
    ./get_glove.bash

# test gloVe
RUN python bow.py

# test infersent tasks
RUN python infersent.py

# test nvidia docker
CMD nvidia-smi -q

# defaults command
CMD ["bash"]