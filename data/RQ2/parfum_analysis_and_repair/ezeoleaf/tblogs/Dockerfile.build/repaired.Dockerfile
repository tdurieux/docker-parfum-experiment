FROM golang:1.13 as build

ARG version=master

RUN git clone https://github.com/ezeoleaf/tblogs.git $GOPATH/src/github.com/ezeoleaf/tblogs && \
    cd $GOPATH/src/github.com/ezeoleaf/tblogs && \
    git checkout $version

ENV GOPROXY=https://proxy.golang.org,direct
ENV GO111MODULE=on
ENV GOSUMDB=off

WORKDIR $GOPATH/src/github.com/ezeoleaf/tblogs

ENV PATH=$PATH:./bin

RUN make build && \
    cp bin/ezeoleaf /usr/local/bin/