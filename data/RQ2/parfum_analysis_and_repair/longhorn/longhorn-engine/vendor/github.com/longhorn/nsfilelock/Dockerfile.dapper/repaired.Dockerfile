FROM ubuntu:16.04

# Setup environment
ENV PATH /go/bin:$PATH
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_ENV TAG REPO
ENV DAPPER_OUTPUT bin
ENV DAPPER_RUN_ARGS --privileged -v /proc:/host/proc
ENV DAPPER_SOURCE /go/src/github.com/longhorn/nsfilelock
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
WORKDIR ${DAPPER_SOURCE}

# Install packages
RUN sed -i "s/http:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y cmake curl git && rm -rf /var/lib/apt/lists/*;
   #  \
   #     libglib2.0-dev libkmod-dev libnl-genl-3-dev linux-libc-dev pkg-config psmisc python-tox qemu-utils fuse python-dev \
   #     devscripts debhelper bash-completion librdmacm-dev libibverbs-dev xsltproc docbook-xsl \
   #     libconfig-general-perl libaio-dev libc6-dev

# Install Go
RUN curl -f -Lo go.tar.gz https://golang.org/dl/go1.14.6.linux-amd64.tar.gz
RUN echo '5c566ddc2e0bcfc25c26a5dc44a440fcc0177f7350c1f01952b34d5989a0d287  go.tar.gz' | sha256sum -c && \
    tar xzf go.tar.gz -C /usr/local && \
    rm go.tar.gz
RUN mkdir -p /go
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH=/go

# Go tools
RUN go get github.com/rancher/trash
RUN go get golang.org/x/lint/golint

# Docker
RUN curl -f -sL https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 > /usr/bin/docker && \
    chmod +x /usr/bin/docker

VOLUME /tmp
ENV TMPDIR /tmp
ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
