FROM golang:1.14

ENV PROJECTPATH=/go/src/github.com/replicatedhq/kotsadm/kurl_proxy
WORKDIR $PROJECTPATH
ADD Makefile ./
ADD go.mod ./
ADD go.sum ./
ADD cmd ./cmd

RUN make build

ADD assets /assets

ENTRYPOINT ["./bin/kurl_proxy"]