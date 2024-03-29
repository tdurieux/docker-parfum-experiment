FROM docker.mirror.hashicorp.services/golang:alpine
LABEL maintainer="The Packer Team <packer@hashicorp.com>"

ENV PACKER_DEV=1

RUN apk add --no-cache git bash openssl ca-certificates
RUN go install github.com/mitchellh/gox@latest
RUN git clone https://github.com/hashicorp/packer $GOPATH/src/github.com/hashicorp/packer

WORKDIR $GOPATH/src/github.com/hashicorp/packer

RUN /bin/bash scripts/build.sh

WORKDIR $GOPATH
ENTRYPOINT ["bin/packer"]