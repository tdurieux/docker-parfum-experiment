FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl \
    wget \
    git-core \
    gcc \
    g++ \
    cmake \
    python \
    python2.7 \
    python2.7-dev \
    zlib1g-dev \
    bzip2 \
    libyaml-dev \
    libyaml-0-2 && rm -rf /var/lib/apt/lists/*;
RUN wget https://releases.numenta.org/pip/1ebd3cb7a5a3073058d0c9552ab074bd/get-pip.py -O - | python
RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir wheel

ENV CC gcc
ENV CXX g++

ADD . /usr/local/src/nupic.core

WORKDIR /usr/local/src/nupic.core

# Explicitly specify --cache-dir, --build, and --no-clean so that build
# artifacts may be extracted from the container later.  Final built python
# packages can be found in /usr/local/src/nupic.core/bindings/py/dist

RUN pip install --no-cache-dir \
        --cache-dir /usr/local/src/nupic.core/pip-cache \
        --build /usr/local/src/nupic.core/pip-build \
        --no-clean \
        pycapnp==0.6.3 \
        -r bindings/py/requirements.txt && \
    python setup.py bdist bdist_dumb bdist_wheel sdist
