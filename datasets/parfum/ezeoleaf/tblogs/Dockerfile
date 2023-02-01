FROM golang:1.13-alpine as build

ARG version=master

RUN apk add git make ncurses && \
    git clone https://github.com/ezeoleaf/tblogs.git $GOPATH/src/github.com/ezeoleaf/tblogs && \
    cd $GOPATH/src/github.com/ezeoleaf/tblogs && \
    git checkout $version

ENV GOPROXY=https://proxy.golang.org,direct
ENV GO111MODULE=on
ENV GOSUMDB=off

WORKDIR $GOPATH/src/github.com/ezeoleaf/tblogs

ENV PATH=$PATH:./bin

RUN make build

FROM alpine

COPY --from=build /go/src/github.com/ezeoleaf/tblogs/bin/tblogs /usr/local/bin/
RUN adduser -h /config -DG users -u 20000 tblogs

USER tblogs
ENTRYPOINT ["tblogs"]
