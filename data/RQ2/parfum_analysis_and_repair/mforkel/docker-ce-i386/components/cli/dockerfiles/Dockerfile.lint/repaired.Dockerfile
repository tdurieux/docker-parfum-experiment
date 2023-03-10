FROM    golang:1.9.4-alpine3.6

RUN apk add --no-cache -U git

ARG     GOMETALINTER_SHA=7f9672e7ea538b8682e83395d50b12f09bb17b91
RUN     go get -d github.com/alecthomas/gometalinter && \
        cd /go/src/github.com/alecthomas/gometalinter && \
        git checkout -q "$GOMETALINTER_SHA" && \
        go build -v -o /usr/local/bin/gometalinter . && \ 
        gometalinter --install && \
        rm -rf /go/src/* /go/pkg/*

ARG     NAKEDRET_SHA=3ddb495a6d63bc9041ba843e7d651cf92639d8cb
RUN     go get -d github.com/alexkohler/nakedret && \
        cd /go/src/github.com/alexkohler/nakedret && \
        git checkout -q "$NAKEDRET_SHA" && \
        go build -v -o /usr/local/bin/nakedret . && \
        rm -rf /go/src/* /go/pkg/*

WORKDIR /go/src/github.com/docker/cli
ENV     CGO_ENABLED=0
ENV     DISABLE_WARN_OUTSIDE_CONTAINER=1
ENTRYPOINT ["/usr/local/bin/gometalinter"]
CMD     ["--config=gometalinter.json", "./..."]
