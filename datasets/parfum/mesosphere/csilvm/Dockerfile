# Update the README when this base image and/or the version of lvm2 (below) is updated.
FROM centos:7.3.1611

RUN yum install -y gcc-4.8.5 gcc-c++-4.8.5 make git util-linux xfsprogs file

RUN curl -O https://releases.pagure.org/libaio/libaio-0.3.110.tar.gz && \
    curl https://releases.pagure.org/libaio/libaio-0.3.110.tar.gz.sha256sum | sha256sum --check && \
    tar -xzvf libaio-0.3.110.tar.gz && \
    cd libaio-0.3.110 && \
    make install

ARG LVM_VERSION=LVM2.2.02.183

ENV LVM2_DOWNLOAD_URL https://www.sourceware.org/pub/lvm2/$LVM_VERSION.tgz

RUN curl -fsSL "$LVM2_DOWNLOAD_URL" -o $LVM_VERSION.tgz && \
      tar -xzvf $LVM_VERSION.tgz && \
      cd $LVM_VERSION && \
      ./configure && \
      make && \
      make install && \
      ldconfig && \
      cd .. && \
      rm -f $LVM_VERSION.tgz

ENV GOLANG_VERSION 1.11.5
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 ff54aafedff961eb94792487e827515da683d61a5f9482f668008832631e5d25

RUN rm -rf /usr/local/go && \
      curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz && \
      echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - && \
      tar -C /usr/local -xzf golang.tar.gz && \
      rm -f golang.tar.gz

ENV GOPATH /go
ENV PATH /go/bin:$PATH
ENV PATH /usr/local/go/bin:$PATH
ENV GOLANGCI_LINT_VERSION v1.17.1

RUN mkdir -p /go/src/github.com/golangci/ && \
    cd /go/src/github.com/golangci && \
    git clone https://github.com/golangci/golangci-lint.git --branch=$GOLANGCI_LINT_VERSION && \
    go install -v github.com/golangci/golangci-lint/cmd/golangci-lint && \
    mkdir -p /go/src/github.com/mesosphere/csilvm

# We explicitly disable use of lvmetad as the cache appears to yield inconsistent results,
# at least when running in docker.
RUN sed -i 's/udev_rules = 1/udev_rules = 0/' /etc/lvm/lvm.conf && \
    sed -i 's/udev_sync = 1/udev_sync = 0/' /etc/lvm/lvm.conf && \
    sed -i 's/use_lvmetad = 1/use_lvmetad = 0/' /etc/lvm/lvm.conf

WORKDIR /go/src/github.com/mesosphere/csilvm
