ARG     BUILD_BASE

FROM    ${BUILD_BASE} as dev

RUN     apk add --no-cache \
        bash \
        curl \
        git \
        make \
        mercurial

ARG     GOMETALINTER_TAG=v2.0.11
RUN     go get -d github.com/alecthomas/gometalinter && \
        cd /go/src/github.com/alecthomas/gometalinter && \
        git checkout -q "$GOMETALINTER_TAG" && \
        go build -v -o /usr/local/bin/gometalinter . && \
        gometalinter --install && \
        rm -rf /go/src/* /go/pkg/*

ARG     NAKEDRET_SHA=3ddb495a6d63bc9041ba843e7d651cf92639d8cb
RUN     go get -d github.com/alexkohler/nakedret && \
        cd /go/src/github.com/alexkohler/nakedret && \
        git checkout -q "$NAKEDRET_SHA" && \
        go build -v -o /usr/local/bin/nakedret . && \
        rm -rf /go/src/* /go/pkg/*

ARG     DEP_VERSION=v0.5.1
RUN     curl -o /usr/bin/dep -L https://github.com/golang/dep/releases/download/${DEP_VERSION}/dep-linux-amd64 && \
        chmod +x /usr/bin/dep

WORKDIR /go/src/github.com/docker/compose-on-kubernetes
COPY    . /go/src/github.com/docker/compose-on-kubernetes
RUN     chmod +x ./scripts/*
ENV     CGO_ENABLED=0

FROM    dev as lint
ENTRYPOINT ["/usr/local/bin/gometalinter"]
CMD     ["--config=gometalinter.json", "./..."]
