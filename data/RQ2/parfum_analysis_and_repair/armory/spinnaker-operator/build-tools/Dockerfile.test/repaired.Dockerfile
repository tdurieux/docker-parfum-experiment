ARG BUILDER
FROM ${BUILDER} as builder

ENV GO111MODULE=on GOOS=linux GOARCH=amd64
WORKDIR /opt/spinnaker-operator/build/
RUN make test OS=linux ARCH=amd64