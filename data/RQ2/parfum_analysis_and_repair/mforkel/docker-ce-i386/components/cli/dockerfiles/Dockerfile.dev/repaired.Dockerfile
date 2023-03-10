FROM    golang:1.9.4-alpine3.6

RUN apk add --no-cache -U git make bash coreutils ca-certificates

ARG     VNDR_SHA=a6e196d8b4b0cbbdc29aebdb20c59ac6926bb384
RUN     go get -d github.com/LK4D4/vndr && \
        cd /go/src/github.com/LK4D4/vndr && \
        git checkout -q "$VNDR_SHA" && \
        go build -v -o /usr/bin/vndr . && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

ARG     ESC_SHA=58d9cde84f237ecdd89bd7f61c2de2853f4c5c6e
RUN     go get -d github.com/mjibson/esc && \
        cd /go/src/github.com/mjibson/esc && \
        git checkout -q "$ESC_SHA" && \
        go build -v -o /usr/bin/esc . && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

ARG     FILEWATCHER_SHA=2e12ea42f6c8c089b19e992145bb94e8adaecedb
RUN     go get -d github.com/dnephin/filewatcher && \
        cd /go/src/github.com/dnephin/filewatcher && \
        git checkout -q "$FILEWATCHER_SHA" && \
        go build -v -o /usr/bin/filewatcher . && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

ENV     CGO_ENABLED=0 \
        PATH=$PATH:/go/src/github.com/docker/cli/build \
        DISABLE_WARN_OUTSIDE_CONTAINER=1
WORKDIR /go/src/github.com/docker/cli
CMD     sh
