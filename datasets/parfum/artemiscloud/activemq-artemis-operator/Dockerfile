# Build the manager binary
FROM golang:1.16 as builder

ENV GOOS=linux
ENV CGO_ENABLED=0
ENV BROKER_NAME=activemq-artemis

RUN mkdir -p /tmp/activemq-artemis-operator

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY pkg/ pkg/
COPY version/ version/
COPY entrypoint/ entrypoint/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /tmp/activemq-artemis-operator/${BROKER_NAME}-operator main.go

FROM registry.access.redhat.com/ubi8:8.6-855 AS base-env

ENV BROKER_NAME=activemq-artemis
ENV OPERATOR=/home/${BROKER_NAME}-operator/bin/${BROKER_NAME}-operator
ENV USER_UID=1000
ENV USER_NAME=${BROKER_NAME}-operator
ENV CGO_ENABLED=0
ENV GOPATH=/tmp/go
ENV JBOSS_IMAGE_NAME="amq7/amq-broker-rhel8-operator"
ENV JBOSS_IMAGE_VERSION="1.0"

WORKDIR /

COPY --from=builder /tmp/activemq-artemis-operator /home/${BROKER_NAME}-operator/bin
COPY --from=builder /workspace/entrypoint/entrypoint /home/${BROKER_NAME}-operator/bin

RUN useradd ${BROKER_NAME}-operator
RUN chown -R `id -u`:0 /home/${BROKER_NAME}-operator/bin && chmod -R 755 /home/${BROKER_NAME}-operator/bin

USER ${USER_UID}
ENTRYPOINT ["/home/${BROKER_NAME}-operator/bin/entrypoint"]

LABEL com.redhat.component="amq-broker-rhel8-operator-container"
LABEL com.redhat.delivery.appregistry="false"
LABEL description="ActiveMQ Artemis Broker Operator"
LABEL io.k8s.description="An associated operator that handles broker installation, updates and scaling."
LABEL io.k8s.display-name="ActiveMQ Artemis Broker Operator"
LABEL io.openshift.expose-services=""
LABEL io.openshift.s2i.scripts-url="image:///usr/local/s2i"
LABEL io.openshift.tags="messaging,amq,integration,operator,golang"
LABEL maintainer="Roddie Kieley <rkieley@redhat.com>"
LABEL name="amq7/amq-broker-rhel8-operator"
LABEL summary="ActiveMQ Artemis Broker Operator"
LABEL version="1.0"
