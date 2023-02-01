FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
  apt-transport-https \
  git \
  software-properties-common \
  uuid-runtime \
  wget && rm -rf /var/lib/apt/lists/*;

ARG CEPH_VERSION
ENV CEPH_VERSION=${CEPH_VERSION:-nautilus}
ARG CEPH_REPO_URL=https://download.ceph.com/debian-${CEPH_VERSION}/
RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN true && \
  apt-add-repository "deb ${CEPH_REPO_URL} xenial main" && \
  apt-get update && \
  apt-get install --no-install-recommends -y ceph libcephfs-dev librados-dev librbd-dev curl gcc g++ && rm -rf /var/lib/apt/lists/*;

ENV GOTAR=go1.12.16.linux-amd64.tar.gz
RUN true && \
  curl -f -o /tmp/${GOTAR} https://dl.google.com/go/${GOTAR} && \
  tar -x -C /opt/ -f /tmp/${GOTAR} && \
  rm -f /tmp/${GOTAR}

# add user account to test permissions
RUN groupadd -g 1010 bob
RUN useradd -u 1010 -g bob -M bob

ENV PATH="${PATH}:/opt/go/bin"
ENV GOROOT=/opt/go
ENV GO111MODULE=on
ENV GOPATH /go
WORKDIR /go/src/github.com/ceph/go-ceph
VOLUME /go/src/github.com/ceph/go-ceph

COPY micro-osd.sh /
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
