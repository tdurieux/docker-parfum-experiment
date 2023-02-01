FROM golang:1.10.2 as builder
MAINTAINER Jim Bugwadia <jim@nirmata.com>

ENV GOPATH=/workspace/golang/

RUN mkdir -p /workspace/golang/src/github.com/nirmata/kube-static-egress-ip

ADD $PWD /workspace/golang/src/github.com/nirmata/kube-static-egress-ip

WORKDIR /workspace/golang/src/github.com/nirmata/kube-static-egress-ip/cmd/static-egressip-controller/

RUN CGO_ENABLED=0 go install -ldflags "-s" -v

FROM alpine:3.8
RUN apk --no-cache add iproute2 iptables ipset
WORKDIR /root/
COPY --from=builder /workspace/golang/bin/static-egressip-controller /usr/local/bin/static-egressip-controller

ENTRYPOINT ["/usr/local/bin/static-egressip-controller"]