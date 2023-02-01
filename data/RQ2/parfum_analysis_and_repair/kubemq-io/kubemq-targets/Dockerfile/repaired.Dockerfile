#FROM kubemq/gobuilder as builder
FROM kubemq/gobuilder-ubuntu:latest as builder
ARG VERSION
ARG GIT_COMMIT
ARG BUILD_TIME
ENV GOPATH=/go
ENV PATH=$GOPATH:$PATH
ENV ADDR=0.0.0.0
ADD . $GOPATH/github.com/kubemq-io/kubemq-targets
WORKDIR $GOPATH/github.com/kubemq-io/kubemq-targets
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -tags container -a -mod=vendor -installsuffix cgo -ldflags="-w -s -X main.version=$VERSION" -o kubemq-targets-run .
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
#RUN microdnf install yum \
#  && yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical \
#  && yum clean all \
#  && microdnf remove yum \
#  && microdnf clean all