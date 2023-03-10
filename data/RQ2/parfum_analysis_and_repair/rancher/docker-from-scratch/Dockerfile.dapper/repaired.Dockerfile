FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install locales sudo vim less curl wget git rsync build-essential isolinux xorriso gccgo \
        libblkid-dev libmount-dev libselinux1-dev cpio genisoimage qemu-kvm python-pip ca-certificates pkg-config tox && rm -rf /var/lib/apt/lists/*;

COPY ./scripts/install-libs.sh /tmp/
RUN /tmp/install-libs.sh

RUN wget -O - https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz | tar -xz -C /usr/local
RUN wget -O /usr/local/bin/docker -L https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 && \
    chmod +x /usr/local/bin/docker

ENV PATH /usr/local/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

ENV DAPPER_SOURCE /go/src/github.com/rancher/docker-from-scratch
ENV DAPPER_OUTPUT ""
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_ENV NO_TEST ARCH

RUN mkdir -p ${DAPPER_SOURCE}/assets && ln -s ${DAPPER_SOURCE} /source

WORKDIR ${DAPPER_SOURCE}/assets

RUN wget https://github.com/rancher/docker-from-scratch/releases/download/bin-v0.4.0/base-files_amd64.tar.gz && \
    wget https://github.com/rancher/docker-from-scratch/releases/download/bin-v0.4.0/base-files_arm.tar.gz && \
    wget https://github.com/rancher/docker-from-scratch/releases/download/bin-v0.4.0/base-files_arm64.tar.gz

ENV DOCKER_VERSION=1.11.2 DOCKER_PATCH_VERSION=v1.11.2-ros1
ENV VERSION=v${DOCKER_VERSION}-2

RUN wget -O docker-${DOCKER_VERSION}_amd64.tgz -L https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && \
    wget -L https://github.com/rancher/docker/releases/download/${DOCKER_PATCH_VERSION}/docker-${DOCKER_VERSION}_arm.tgz && \
    wget -L https://github.com/rancher/docker/releases/download/${DOCKER_PATCH_VERSION}/docker-${DOCKER_VERSION}_arm64.tgz

WORKDIR ${DAPPER_SOURCE}

CMD ./scripts/ci
