FROM ubuntu:bionic-20190807

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q \
      apt-utils autoconf bison build-essential flex gawk gdb-multiarch git gperf help2man \
      libexpat-dev libncurses5-dev libtool-bin \
      python python-dev python-git python-pyelftools python-serial python-six python-yaml \
      python3 python3-dev python3-git python3-pyelftools python3-serial python3-six python3-yaml \
      software-properties-common texinfo unzip wget zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q \
      clang libavahi-client-dev libcap-dev valgrind && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /opt -m -s /bin/bash user && chown -R user /opt

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG DOCKER_TAG
ENV MGOS_SDK_REVISION $DOCKER_TAG
ENV MGOS_SDK_BUILD_IMAGE docker.io/mgos/ubuntu-build:$DOCKER_TAG
