FROM resin/rpi-raspbian

USER root

RUN apt-get update && apt-get -qy --no-install-recommends install git nano curl wget build-essential ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN wget --no-check-certificate \
   https://storage.googleapis.com/golang/go1.6.2.linux-armv6l.tar.gz

RUN tar -xf go*.tar.gz -C /usr/local/ && rm go*.tar.gz

ENV PATH \
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin
RUN mkdir /go
ENV GOPATH /go
ENV AUTO_GOPATH 1
RUN go version
RUN AUTO_GOPATH=1 go get github.com/tools/godep

CMD ["go version"]
