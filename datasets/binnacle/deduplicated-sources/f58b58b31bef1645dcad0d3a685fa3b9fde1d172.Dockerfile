FROM    golang:1.10-alpine
RUN     apk add -U git bash curl tree

ARG     FILEWATCHER_SHA=v0.3.0
RUN     go get -d github.com/dnephin/filewatcher && \
        cd /go/src/github.com/dnephin/filewatcher && \
        git checkout -q "$FILEWATCHER_SHA" && \
        go build -v -o /usr/bin/filewatcher . && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

ARG     DEP_TAG=v0.4.1
RUN     go get -d github.com/golang/dep/cmd/dep && \
        cd /go/src/github.com/golang/dep && \
        git checkout -q "$DEP_TAG" && \
        go build -v -o /usr/bin/dep ./cmd/dep && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

ARG     GOTESTSUM=v0.3.0
RUN     go get -d gotest.tools/gotestsum && \
        cd /go/src/gotest.tools/gotestsum && \
        git checkout -q "$GOTESTSUM" && \
        go build -v -o /usr/bin/gotestsum . && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

RUN     go get github.com/mitchellh/gox && \
        cp /go/bin/gox /usr/bin && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

RUN     go get -d github.com/golang/mock/mockgen && \
        cd /go/src/github.com/golang/mock && \
        git checkout -q "v1.0.0" && \
        go build -v -o /usr/local/bin/mockgen ./mockgen && \
        rm -rf /go/src/* /go/pkg/* /go/bin/*

WORKDIR /go/src/github.com/dnephin/dobi
ENV     PS1="# "
ENV     CGO_ENABLED=0
