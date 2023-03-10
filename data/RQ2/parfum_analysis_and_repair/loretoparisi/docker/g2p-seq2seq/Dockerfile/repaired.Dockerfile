#
# g2p-seq2seq
# G2P with Tensorflow
# The tool does Grapheme-to-Phoneme (G2P) conversion using recurrent neural network (RNN)
# with long short-term memory units (LSTM).
#
# @see https://github.com/cmusphinx/g2p-seq2seq
#
# Copyright (c) 2018 Loreto Parisi - https://github.com/loretoparisi/docker
#

FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Loreto Parisi loretoparisi@gmail.com

# working directory
ENV HOME /root
WORKDIR $HOME

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    curl \
    wget \
    vim \
    python-pip python-dev \
    ipython && rm -rf /var/lib/apt/lists/*;

# pip
RUN pip install --no-cache-dir --upgrade pip

# tensorflow >= 1.3.0 and tensor2tensor >= 1.4.0
RUN export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
RUN \
    pip install --no-cache-dir tensorflow-gpu==1.4.0 && \
    pip install --no-cache-dir tensor2tensor==1.5.7

# download CMU Dict
RUN \
    git clone https://github.com/cmusphinx/cmudict

# install g2p-seq2seq.git
RUN git clone https://github.com/cmusphinx/g2p-seq2seq
COPY src/setup.py g2p-seq2seq/setup.py
RUN \
    cd g2p-seq2seq/ && \
    python setup.py install && \
    cd -

CMD ["bash"]
