FROM golang:1.18 AS builder

ARG VERSION=latest
ARG LFLAGS

ENV \
  KUBECTL_VERSION="1.23.0"

ENV \
  KUBECTL_BINARY_URL=https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN curl -f -sL -o /usr/bin/kubectl ${KUBECTL_BINARY_URL} && chmod +x /usr/bin/kubectl

COPY . /go/src/github.com/appvia/terraform-controller

ENV CGO_ENABLED=0
ENV VERSION=$VERSION

RUN /usr/bin/kubectl version --client

RUN cd /go/src/github.com/appvia/terraform-controller && make source
RUN cd /go/src/github.com/appvia/terraform-controller && make step

FROM alpine:3.15.4

RUN apk add --no-cache ca-certificates curl unzip

RUN apk add --no-cache ca-certificates bash openssh git

COPY --from=builder /usr/bin/kubectl /bin/kubectl
COPY --from=builder /go/src/github.com/appvia/terraform-controller/bin/source /bin/source
COPY --from=builder /go/src/github.com/appvia/terraform-controller/bin/step /bin/step

COPY images/assets/ssh_config /etc/ssh/ssh_config

USER 1001
