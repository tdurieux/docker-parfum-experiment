FROM golang:1.17 as builder

WORKDIR /go/src/github.com/red-hat-storage/ocs-operator
COPY . .
USER root
RUN make build-go

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=builder /go/src/github.com/red-hat-storage/ocs-operator/build/_output/bin/ocs-operator /usr/local/bin/ocs-operator
COPY --from=builder /go/src/github.com/red-hat-storage/ocs-operator/build/_output/bin/metrics-exporter /usr/local/bin/metrics-exporter
COPY --from=builder /go/src/github.com/red-hat-storage/ocs-operator/metrics/deploy/*rules*.yaml /ocs-prometheus-rules/