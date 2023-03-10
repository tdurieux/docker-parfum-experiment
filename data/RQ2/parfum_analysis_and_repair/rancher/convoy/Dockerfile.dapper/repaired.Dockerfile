FROM ubuntu:16.04

ARG DAPPER_HOST_ARCH=amd64
ARG http_proxy
ARG https_proxy
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH}

# Install packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        cmake \
        curl \
        git \
	wget \
	vim \
	less \
	file \
        libglib2.0-dev \
        libkmod-dev \
        libnl-genl-3-dev \
        linux-libc-dev \
        pkg-config \
        psmisc \
        python-tox && \
    rm -f /bin/sh && ln -s /bin/bash /bin/sh && rm -rf /var/lib/apt/lists/*;

ENV DOCKER_URL_amd64=https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 \
    DOCKER_URL_arm=https://github.com/rancher/docker/releases/download/v1.10.3-ros1/docker-1.10.3_arm \
    DOCKER_URL=DOCKER_URL_${ARCH}

RUN wget -O - ${!DOCKER_URL} > /usr/bin/docker && chmod +x /usr/bin/docker

ENV GOLANG_ARCH_amd64=amd64 GOLANG_ARCH_arm=armv6l GOLANG_ARCH=GOLANG_ARCH_${ARCH} \
    GOPATH=/go PATH=/go/bin:/usr/local/go/bin:${PATH} SHELL=/bin/bash

RUN wget -O - https://storage.googleapis.com/golang/go1.9.6.linux-${!GOLANG_ARCH}.tar.gz | tar -xzf - -C /usr/local && \
    go get github.com/rancher/trash && go get github.com/golang/lint/golint

# Install liblvm2
RUN curl -f -o lvm.tar.gz https://s3-us-west-1.amazonaws.com/sheng/LVM2.2.02.103.tgz && \
					tar xzf lvm.tar.gz -C /usr/local/ && \
					cd /usr/local/LVM2.2.02.103 && \
					./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-static_link && \
					make device-mapper && \
					make install_device-mapper && rm lvm.tar.gz

# Install convoy-pdata_tools
RUN curl -f -sL https://github.com/rancher/thin-provisioning-tools/releases/download/convoy-v0.2.1/convoy-pdata_tools > /usr/local/bin/convoy-pdata_tools && \
					chmod a+x /usr/local/bin/convoy-pdata_tools

# Setup environment
ENV PATH /go/bin:$PATH
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_ENV TAG REPO
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_RUN_ARGS --privileged
ENV DAPPER_SOURCE /go/src/github.com/rancher/convoy
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
WORKDIR ${DAPPER_SOURCE}

VOLUME /tmp
ENV TMPDIR /tmp
ENTRYPOINT ["./scripts/entry"]
CMD ["build"]
