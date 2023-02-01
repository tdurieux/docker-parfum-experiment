FROM ubuntu:20.04 as base

ARG TARGETARCH

RUN export DEBIAN_FRONTEND=noninteractive \
  && sed -i 's/\(archive\|security\|ports\).ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list \
  && apt-get update && apt-get install --no-install-recommends -y git make curl tree tzdata \
  && apt-get install --no-install-recommends -y clang llvm \
  && apt-get install --no-install-recommends -y gcc \
  && if [ "${TARGETARCH}" = "amd64" ]; then \
  apt-get install --no-install-recommends -y gcc-multilib; fi && rm -rf /var/lib/apt/lists/*;

ENV DK_BUILD_GO_VERSION=1.18.3

RUN curl -f -Lo go${DK_BUILD_GO_VERSION}.linux-${TARGETARCH}.tar.gz https://go.dev/dl/go${DK_BUILD_GO_VERSION}.linux-${TARGETARCH}.tar.gz \
  && rm -rf /usr/local/go \
  && tar -C /usr/local/ -xzf go${DK_BUILD_GO_VERSION}.linux-${TARGETARCH}.tar.gz \
  && rm -rf /usr/local/go${DK_BUILD_GO_VERSION} \
  && mv /usr/local/go /usr/local/go${DK_BUILD_GO_VERSION} \
  && rm go${DK_BUILD_GO_VERSION}.linux-${TARGETARCH}.tar.gz

ENV PATH=$PATH:/usr/local/go${DK_BUILD_GO_VERSION}/bin GOROOT=/usr/local/go${DK_BUILD_GO_VERSION}

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.46.2 \
  && go install github.com/gobuffalo/packr/v2/packr2@latest \
  && go install mvdan.cc/gofumpt@latest \
  && go install golang.org/x/tools/cmd/goyacc@latest \
  && go install -a -v github.com/go-bindata/go-bindata/...@latest \
  && cp -r $HOME/go/bin/* /usr/local/bin

ENV KERNEL_SRC_VERSION=5.4.0-99-generic
ENV DK_BPF_KERNEL_SRC_PATH=/usr/src/linux-headers-${KERNEL_SRC_VERSION}

RUN mkdir -p /root/go/src/gitlab.jiagouyun.com/cloudcare-tools/ \
  && apt-get install --no-install-recommends -y linux-headers-${KERNEL_SRC_VERSION} && rm -rf /var/lib/apt/lists/*;
