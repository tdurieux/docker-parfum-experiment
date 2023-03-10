# bitflowstream/golang-build:debian
# This image is used to build Go programs on Debian hosts. The purpose of this separate container
# is to mount the Go mod-cache into the container during the build, which is not possible with the 'docker build' command.

# This image is intended to be run on the build host with a volume such as: -v /tmp/go-mod-cache/debian:/go
# When /tmp/go-mod-cache/debian is cleared manually, the following commands should be executed afterwards:
# docker run -v /tmp/go-mod-cache/debian:/go -ti bitflowstream/golang-build:debian go get -u github.com/jstemmer/go-junit-report
# docker run -v /tmp/go-mod-cache/debian:/go -ti bitflowstream/golang-build:debian go get -u golang.org/x/lint/golint

# docker build -t bitflowstream/golang-build:debian -f debian-build.Dockerfile .
FROM golang:1.14.1-buster
WORKDIR /build
ENV GO111MODULE=on

RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; rm -rf /var/lib/apt/lists/*; apt-key add /tmp/dkey && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce qemu-user mercurial git jq

# Enable docker-cli experimental features
RUN mkdir ~/.docker && echo '{\n\t"experimental": "enabled"\n}' > ~/.docker/config.json
