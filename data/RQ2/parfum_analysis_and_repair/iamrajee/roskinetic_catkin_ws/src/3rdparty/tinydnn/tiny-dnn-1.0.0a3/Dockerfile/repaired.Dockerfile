FROM ubuntu:16.04

MAINTAINER Edgar Riba <edgar.riba@gmail.com>

# Update aptitude with new repo
RUN apt-get update

# Install software
RUN apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    python-pip \
    git && rm -rf /var/lib/apt/lists/*;

# Setup software directories
RUN mkdir -p /software

# Setup dependencies
RUN apt-get install --no-install-recommends -y \
    libpthread-stubs0-dev \
    libtbb-dev && rm -rf /var/lib/apt/lists/*;

# Download and configure PeachPy
RUN cd /software && \
    git clone https://github.com/Maratyszcza/PeachPy.git && \
    cd /software/PeachPy && \
    pip install --no-cache-dir -r requirements.txt && \
    python setup.py generate && \
    pip install --no-cache-dir .

# Download and configure NNPACK
RUN apt-get install -y --no-install-recommends ninja-build && \
    pip install --no-cache-dir ninja-syntax && \
    cd /software && \
    git clone --recursive https://github.com/Maratyszcza/NNPACK.git && \
    cd /software/NNPACK && \
    python ./configure.py && \
    ninja && rm -rf /var/lib/apt/lists/*;

# Download tiny-dnn
RUN cd /software && \
    git clone https://github.com/tiny-dnn/tiny-dnn.git && \
    cd /software/tiny-dnn && \
    git submodule update --init
