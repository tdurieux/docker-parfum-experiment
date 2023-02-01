# Dockerfile for hyperledger fabirc kubernetes operator
#
# @see https://github.com/hyperledger/cello/blob/master/src/agent/fabric-operator/README.md
#

# Use the golang docker image to build the operator binary
FROM golang AS builder
RUN mkdir -p /go/src/github.com/hyperledger/cello/src/agent/fabric-operator
COPY src/agent/fabric-operator /go/src/github.com/hyperledger/cello/src/agent
RUN cd /go/src/github.com/hyperledger/cello/src/agent/fabric-operator && \
  go build -o fabric-operator \
  -gcflags all=-trimpath=/go/src/github.com/hyperledger/cello/src/agent \
  -asmflags all=-trimpath=/go/src/github.com/hyperledger/cello/src/agent \
  github.com/hyperledger/cello/src/agent/fabric-operator/cmd/manager

# Build the fabric kubernetes operator docker image
FROM registry.access.redhat.com/ubi7/ubi-minimal:latest
ENV OPERATOR=/usr/local/bin/fabric-operator \
    USER_UID=1001 \
    USER_NAME=fabric-operator

# Place the operator binary in /usr/local/bin directory
COPY --from=builder /go/src/github.com/hyperledger/cello/src/agent/fabric-operator/fabric-operator ${OPERATOR}
COPY src/agent/fabric-operator/build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}
