FROM golang:1.17.6 as builder

WORKDIR /workspace

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download
COPY cmd cmd
COPY pkg pkg
COPY internal internal
COPY build build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -o build/bin/nfn-operator ./cmd/nfn-operator
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -o build/bin/ovn4nfvk8s-cni ./cmd/ovn4nfvk8s-cni
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -o build/bin/nfn-agent ./cmd/nfn-agent

FROM ubuntu:20.04

ARG CNI_VERSION=v1.0.1
ENV DEBIAN_FRONTEND=noninteractive \
    OPERATOR=/usr/local/bin/nfn-operator \
    AGENT=/usr/local/bin/nfn-agent \
    USER_UID=1001 \
    USER_NAME=nfn-operator \
    CNI_VERSION=$CNI_VERSION
WORKDIR /
COPY --from=builder /workspace/build/bin/* usr/local/bin/
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y -qq \
      apt-transport-https=2.0.8 \
      make=4.2.1-1.2 \
      curl=7.68.0-1ubuntu2.11 \
      net-tools=1.60+git20180626.aebd88e-1ubuntu1 \
      iproute2=5.5.0-1ubuntu1 \
      iptables=1.8.4-3ubuntu2 \
      netcat=1.206-1ubuntu1 \
      jq=1.6-1ubuntu0.20.04.1 \
      ovn-common=20.03.2-0ubuntu0.20.04.3 \
      openvswitch-common=2.13.5-0ubuntu1 \
      openvswitch-switch=2.13.5-0ubuntu1 && \
    mkdir -p /opt/cni/bin && \
    curl -f --insecure --compressed -O -L https://github.com/akraino-icn/plugins/releases/download/$CNI_VERSION/cni-plugins-linux-amd64-$CNI_VERSION.tgz && \
    tar -zxvf cni-plugins-linux-amd64-$CNI_VERSION.tgz -C /opt/cni/bin && \
    rm -rf cni-plugins-linux-amd64-$CNI_VERSION.tgz && \
    apt purge -y curl && \
    apt clean -y && \
    apt autoremove -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["entrypoint"]
