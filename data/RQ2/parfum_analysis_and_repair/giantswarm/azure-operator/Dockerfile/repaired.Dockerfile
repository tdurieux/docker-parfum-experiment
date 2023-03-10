FROM quay.io/giantswarm/golang:1.17.7 AS builder
ENV GO111MODULE=on
COPY go.mod /etc/go.mod
RUN cat /etc/go.mod | grep k8scloudconfig | awk '{print $1"/...@"$2}' | xargs -I{} go get {}
# This is needed to extract the versioned catalog name, e.g. v6@6.0.1
RUN ln -s /go/pkg/mod/$(cat /etc/go.mod | grep k8scloudconfig | awk '{print $1"@"$2}') /opt/k8scloudconfig

FROM alpine:3.16.0

RUN apk add --no-cache --update ca-certificates \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/ignition
COPY --from=builder /opt/k8scloudconfig /opt/ignition

ADD ./azure-operator /azure-operator

ENTRYPOINT ["/azure-operator"]
