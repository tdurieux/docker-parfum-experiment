FROM ubuntu:18.10

RUN apt-get update && apt-get install -y \
    golang \
    libbtrfs-dev \
    git-core \
    libdevmapper-dev \
    libgpgme11-dev \
    go-md2man \
    libglib2.0-dev \
    libostree-dev

ENV GOPATH=/
WORKDIR /src/github.com/containers/skopeo
