FROM quay.io/giantswarm/golang:1.16.6 AS builder

WORKDIR /mod

COPY go.mod go.sum /mod/

RUN K8SCCPATH=$(go list -m -f '{{.Path}}' github.com/giantswarm/k8scloudconfig/...) \
    && go mod download -x $K8SCCPATH \
    && K8SCCROOT=$(go list -m -f '{{.Dir}}' github.com/giantswarm/k8scloudconfig/...) \
    && mv $K8SCCROOT /opt/k8scloudconfig

FROM alpine:3.14.0

RUN apk add --no-cache ca-certificates

RUN mkdir -p /opt/kvm-operator
ADD ./kvm-operator /opt/kvm-operator/kvm-operator

RUN mkdir -p /opt/ignition
COPY --from=builder /opt/k8scloudconfig /opt/ignition

WORKDIR /opt/kvm-operator

EXPOSE 8000
ENTRYPOINT ["/opt/kvm-operator/kvm-operator"]