FROM pyprob/pyprob_cpp:latest

ENV PYTHON_VERSION=3.7
ENV CC=gcc-5
ENV CXX=g++-5

RUN apt-get update && apt-get install -y curl python3 python3-pip python3-gdbm zlib1g-dev libjpeg8-dev
RUN pip3 install torch==1.10.2+cpu torchvision==0.11.3+cpu torchaudio==0.10.2+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html

RUN ln -s $(which python3) /usr/bin/python
WORKDIR /home
COPY . /home/pyprob

RUN pip3 install ./pyprob[dev]
RUN cd pyprob && sh tests/run_basic.sh

ARG PYPROB_VERSION="unknown"
ARG GIT_COMMIT="unknown"

LABEL project="pyprob"
LABEL url="https://github.com/pyprob/pyprob"
LABEL maintainer="Atilim Gunes Baydin <gunes@robots.ox.ac.uk>"
LABEL version=$PYPROB_VERSION
LABEL git_commit=$GIT_COMMIT
