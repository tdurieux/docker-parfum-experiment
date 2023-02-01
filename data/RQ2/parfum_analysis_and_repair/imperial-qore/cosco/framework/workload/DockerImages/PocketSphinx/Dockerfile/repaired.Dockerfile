FROM ubuntu:18.04

WORKDIR /root

ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    libtool \
    automake \
    git \
    gcc \
    bc \
    ffmpeg \
    bison \
    swig \
    python-dev \
    python-pip \
    libpulse-dev && rm -rf /var/lib/apt/lists/*;

RUN \
    apt-get install --no-install-recommends -y \
    wget && rm -rf /var/lib/apt/lists/*;

RUN \
    pip install --no-cache-dir boto3

RUN \
    git init && \
    git remote add -f origin https://github.com/qub-blesson/DeFog.git && \
    git config core.sparsecheckout true && \
    echo PocketSphinx/sphinxbase >> .git/info/sparse-checkout && \
    git pull https://github.com/qub-blesson/DeFog.git master

RUN \
    cd PocketSphinx/sphinxbase/ && \
    chmod 777 autogen.sh && \
    ./autogen.sh && \
    make clean && \
    make && \
    make install && \
    export LD_LIBRARY_PATH=/usr/local/lib && \
    ldconfig && \
    cd pocketsphinx/ && \
    chmod 777 autogen.sh && \
    ./autogen.sh && \
    make clean && \
    make && \
    make install
RUN \
    ldconfig 


COPY execute.sh .
RUN chmod +x execute.sh

COPY assets assets
CMD ["./execute.sh"]

