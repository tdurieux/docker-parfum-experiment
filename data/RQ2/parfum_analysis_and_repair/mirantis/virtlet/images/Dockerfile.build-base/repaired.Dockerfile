# TODO: generate this tag. unfortunately can't use ARG:
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
# (but add a note about it here for the future)
FROM mirantis/virtlet-base:v1-6348ee2277c565d3895260bccb5ada96
MAINTAINER Ivan Shvedunov <ishvedunov@mirantis.com>

LABEL virtlet.image="build-base"

ENV DOCKER_CLIENT_VERSION 17.03.0-ce
ENV DOCKER_CLIENT_DOWNLOAD_URL_BASE https://download.docker.com/linux/static/stable
ENV DOCKER_CLIENT_SHA256 27f6cbbe189fd6374bedbc406df48462e34d7e6ab2c8c6cc4135c38eb63b0b5d
# TODO: bump kubectl
ENV KUBECTL_VERSION v1.9.3
ENV KUBECTL_SHA1 a27d808eb011dbeea876fe5326349ed167a7ed28
ENV OLD_KUBECTL_VERSION v1.7.12
ENV OLD_KUBECTL_SHA1 385229d4189e4f7978de42f237d6c443c0534edd

# Go installation commands are based on official Go container:
# https://github.com/docker-library/golang/blob/18ee81a2ec649dd7b3d5126b24eef86bc9c86d80/1.7/Dockerfile
ENV GOLANG_VERSION 1.10.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035

ENV CIRROS_SHA256 fcd9e9a622835de8dba6b546481d13599b1e592bba1275219e1b31cae33b1365

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                git \
                make \
                autoconf \
                automake \
                p7zip-full \
                dhcpcd5 \
                tcpdump \
                iputils-ping \
                mercurial \
                pkg-config \
                python-pip && \
    apt-get clean && \
    pip install --no-cache-dir mkdocs && rm -rf /var/lib/apt/lists/*;

# Install docker client
RUN mkdir -p /usr/local/bin && \
    curl -f -sSL "${DOCKER_CLIENT_DOWNLOAD_URL_BASE}/$(uname -m)/docker-${DOCKER_CLIENT_VERSION}.tgz" | \
    tar -C /usr/local/bin -xz --strip-components=1 docker/docker && \
    echo "${DOCKER_CLIENT_SHA256}  /usr/local/bin/docker" | sha256sum -c -

# Install Go
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH /go/src/github.com/Mirantis/virtlet/_output:$GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

# Install kubectl.
# Also install old kubectl for v1.7 (needed to make the release yaml)
RUN curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    echo "${KUBECTL_SHA1}  /usr/local/bin/kubectl" | sha1sum -c && \
    chmod +x /usr/local/bin/kubectl && \
    curl -f -L https://storage.googleapis.com/kubernetes-release/release/${OLD_KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl.old && \
    echo "${OLD_KUBECTL_SHA1}  /usr/local/bin/kubectl.old" | sha1sum -c && \
    chmod +x /usr/local/bin/kubectl.old

# TODO: update CNI ver
RUN mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    mkdir -p /var/lib/virtlet/volumes /opt/cni/bin && \
    curl -f -L https://github.com/containernetworking/cni/releases/download/v0.3.0/cni-v0.3.0.tgz | \
      tar zxC /opt/cni/bin && \
    ln -s /go/src/github.com/Mirantis/virtlet/_output/vmwrapper /vmwrapper

# Download cirros image
RUN mkdir -p /images && \
    curl -f -L https://github.com/Mirantis/virtlet/releases/download/v0.8.2/cirros.img -o /images/cirros.img && \
    echo "${CIRROS_SHA256}  /images/cirros.img" | sha256sum -c -

# Install Go tooling
RUN go get github.com/aktau/github-release && \
    go get github.com/Masterminds/glide && \
    go get github.com/go-bindata/go-bindata/...
