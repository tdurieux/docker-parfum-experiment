# BASE IMAGE
FROM continuumio/miniconda3

SHELL ["/bin/bash","-c"]

WORKDIR /opt

RUN apt-get update && apt-get -y --no-install-recommends install git gcc g++ liblapack-dev libblas-dev libboost-dev libarmadillo-dev libfftw3-dev \
    && git clone https://github.com/xulabs/aitom.git && cd aitom \
    && pip install --no-cache-dir cython numpy==1.19.2 \
    && bash build.sh && rm -rf /var/lib/apt/lists/*;

EXPOSE 8888

