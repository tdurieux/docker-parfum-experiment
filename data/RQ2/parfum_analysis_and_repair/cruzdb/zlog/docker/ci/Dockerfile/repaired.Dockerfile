FROM ubuntu:14.04

MAINTAINER Noah Watkins <noahwatkins@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y git wget && rm -rf /var/lib/apt/lists/*;

# built ceph/rados bits
RUN wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/autobuild.asc' | sudo apt-key add -
RUN echo deb http://gitbuilder.ceph.com/ceph-deb-$(lsb_release -sc)-x86_64-basic/ref/jewel $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes ceph librados-dev && rm -rf /var/lib/apt/lists/*;

# ceph dev deps
RUN mkdir /src && cd /src && \
  git clone --branch=jewel --recursive https://github.com/ceph/ceph.git && \
  cd ceph && \
  bash ./install-deps.sh

# zlog dev deps
RUN apt-get install --no-install-recommends -y libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists/*;

ADD micro-osd.sh /src/micro-osd.sh
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
