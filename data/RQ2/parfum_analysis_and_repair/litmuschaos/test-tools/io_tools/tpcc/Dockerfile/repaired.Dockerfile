FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  mysql-client \
  jq \
  gcc \
  libc6-dev \
  zlib1g-dev \
  libssl-dev \
  make \
  libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

ADD tpcc-mysql/ /tpcc-mysql
ENV PATH /tpcc-mysql:$PATH
WORKDIR /tpcc-mysql
RUN cd src && make
