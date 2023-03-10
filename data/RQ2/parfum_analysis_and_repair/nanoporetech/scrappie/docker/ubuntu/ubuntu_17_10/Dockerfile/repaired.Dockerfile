FROM ubuntu:17.10
MAINTAINER Tim Massingham <tim.massingham@nanoporetech.com>
RUN apt-get update && apt-get install -y --no-install-recommends  \
    ca-certificates gcc git libopenblas-dev libhdf5-dev cmake make libcunit1-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://github.com/nanoporetech/scrappie.git

RUN cd scrappie && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make test

