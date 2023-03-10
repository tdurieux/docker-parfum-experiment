FROM golang:1.16.0-buster

RUN apt-get update

RUN go get github.com/go-delve/delve/cmd/dlv

ENV SRC_DIR /textile

COPY go.mod go.sum $SRC_DIR/
RUN cd $SRC_DIR \
  && go mod download

COPY . $SRC_DIR

RUN cd $SRC_DIR \
  && CGO_ENABLED=0 GOOS=linux go build -gcflags "all=-N -l" -o hubd cmd/hubd/main.go

FROM debian:buster
LABEL maintainer="Textile <contact@textile.io>"

ENV SRC_DIR /textile
COPY --from=0 /go/bin/dlv /usr/local/bin/dlv
COPY --from=0 $SRC_DIR/hubd /usr/local/bin/hubd

EXPOSE 3006
EXPOSE 3007
EXPOSE 4006
EXPOSE 8006
EXPOSE 40000

ENV TEXTILE_PATH /data/textile
RUN adduser --home $TEXTILE_PATH --disabled-login --gecos "" --ingroup users textile

USER textile

VOLUME $TEXTILE_PATH

ENTRYPOINT ["dlv", "--listen=0.0.0.0:40000", "--headless=true", "--accept-multiclient", "--continue", "--api-version=2", "exec", "/usr/local/bin/hubd"]

CMD ["--", "--repo=/data/textile"]