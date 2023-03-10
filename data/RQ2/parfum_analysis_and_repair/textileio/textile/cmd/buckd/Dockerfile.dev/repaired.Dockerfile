FROM golang:1.16.0-buster

RUN apt-get update

RUN go get github.com/go-delve/delve/cmd/dlv

ENV SRC_DIR /textile

COPY go.mod go.sum $SRC_DIR/
RUN cd $SRC_DIR \
  && go mod download

COPY . $SRC_DIR

RUN cd $SRC_DIR \
  && CGO_ENABLED=0 GOOS=linux go build -gcflags "all=-N -l" -o buckd cmd/buckd/main.go

FROM debian:buster
LABEL maintainer="Textile <contact@textile.io>"

ENV SRC_DIR /textile
COPY --from=0 /go/bin/dlv /usr/local/bin/dlv
COPY --from=0 $SRC_DIR/buckd /usr/local/bin/buckd

EXPOSE 3006
EXPOSE 3007
EXPOSE 4006
EXPOSE 8006
EXPOSE 40000

ENV BUCKETS_PATH /data/buckets
RUN adduser --home $BUCKETS_PATH --disabled-login --gecos "" --ingroup users buckets

USER buckets

VOLUME $BUCKETS_PATH

ENTRYPOINT ["dlv", "--listen=0.0.0.0:40000", "--headless=true", "--accept-multiclient", "--continue", "--api-version=2", "exec", "/usr/local/bin/buckd"]

CMD ["--", "--repo=/data/buckets"]