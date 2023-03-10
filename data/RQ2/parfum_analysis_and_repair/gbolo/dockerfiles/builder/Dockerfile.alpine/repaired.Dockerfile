# github.com/gbolo/dockerfiles/builder/Dockerfile.alpine

ARG     go_version=1.13.1
FROM    golang:${go_version}-alpine3.10 as golang

FROM  gbolo/baseos:alpine

# DEFAULTS
ENV     GOROOT=/opt/go \
        GOPATH=/opt/gopath

ENV     PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin

# install go from official golang image
COPY --from=golang /usr/local/go /opt/go

# SETUP DEV TOOLS
RUN set -xe; \
# upgrade all packages
        apk upgrade --no-progress --no-cache && \
# install everything we may want (it's OK to repeat pkgs!)
        apk add --no-cache build-base alpine-sdk \
           git gcc libtool musl musl-dev file openssl-dev openssl \
           g++ make curl ca-certificates patch bash \
           python2 python3 python2-dev python3-dev py2-pip \
           php nodejs nodejs-npm nodejs-dev && \
        pip3 install --no-cache-dir --upgrade pip setuptools && \
        pip2 install --no-cache-dir --upgrade pip setuptools && \
# get gopath ready
        mkdir -p ${GOPATH}




ENTRYPOINT  ["/bin/bash"]
