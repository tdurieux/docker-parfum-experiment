# Dockerfile to build DMTCP container images.
FROM ubuntu:15.04
MAINTAINER Kapil Arya <kapil@ccs.neu.edu>

RUN apt-get update -q && apt-get -qy --no-install-recommends install \
      build-essential \
      git-core \
      make && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /dmtcp
RUN mkdir -p /tmp

WORKDIR /dmtcp
RUN git clone https://github.com/dmtcp/dmtcp.git /dmtcp && \
      git checkout master &&                    \
      git log -n 1

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j 2 && make install
