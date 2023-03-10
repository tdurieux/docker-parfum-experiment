FROM golang:1.5

# TODO: Vendor these `go get` commands using Godep.
RUN \
  go get github.com/mitchellh/gox && \
  go get github.com/aktau/github-release && \
  go get github.com/pwaller/goupx && \
  go get github.com/codegangsta/cli && \
  go get github.com/coreos/go-systemd/activation && \
  go get github.com/miekg/dns && \
  go get github.com/rcrowley/go-metrics && \
  go get github.com/rcrowley/go-metrics/stathat && \
  go get github.com/Sirupsen/logrus && \
  go get github.com/stathat/go

ENV USER root

ADD . /go/src/github.com/janeczku/go-dnsmasq

COPY scripts/upx /usr/local/bin/

RUN chmod +x /usr/local/bin/upx

WORKDIR /go/src/github.com/janeczku/go-dnsmasq