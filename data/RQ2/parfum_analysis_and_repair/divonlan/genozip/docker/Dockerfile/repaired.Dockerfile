FROM ubuntu:18.04

RUN apt-get update && \
	apt-get install --no-install-recommends -y build-essential git cmake autoconf libtool pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /genozip
RUN git clone --depth 1 https://github.com/divonlan/genozip.git /genozip && cd /genozip && make docker

WORKDIR /data
ENV PATH /genozip:$PATH