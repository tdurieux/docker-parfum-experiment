ARG UBUNTU_VERSION="20.04"
ARG GO_VERSION="1.18.3"

FROM ubuntu:${UBUNTU_VERSION} AS base
RUN export DEBIAN_FRONTEND="noninteractive" \
  && apt-get update \
  && apt-get install --no-install-recommends -y software-properties-common \
  && add-apt-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    bash \
    binutils \
    ca-certificates \
    clang \
    curl \
    g++ \
    gcc \
    git \
    libc6-dev \
    libssl-dev \
    llvm \
    make \
    pkg-config \
    tzdata \
    uuid \
  && apt-get -y autoremove \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -sf /usr/include/asm-generic /usr/include/asm

FROM base AS golang
RUN export DEBIAN_FRONTEND="noninteractive" && apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
WORKDIR /golang
RUN curl -f -m30 --retry 5 --retry-connrefused --retry-delay 5 -sSL "https://go.dev/dl/?mode=json&include=all" -o "godist.json"
ARG GO_VERSION
ARG TARGETOS
ARG TARGETARCH
ENV PATH="/usr/local/go/bin:$PATH"
RUN <<EOT
GO_DIST_FILE=go${GO_VERSION%.0}.${TARGETOS}-${TARGETARCH}.tar.gz
GO_DIST_URL=https://golang.org/dl/${GO_DIST_FILE}
SHA256=$(cat godist.json | jq -r ".[] | select(.version==\"go${GO_VERSION%.0}\") | .files[] | select(.filename==\"$GO_DIST_FILE\").sha256")
curl -sSL "$GO_DIST_URL.asc" -o "go.tgz.asc"
curl -sSL "$GO_DIST_URL" -o "go.tgz"
echo "$SHA256 *go.tgz" | sha256sum -c -
tar -C /usr/local -xzf go.tgz
go version
EOT

FROM base
COPY --from=golang /usr/local/go /usr/local/go

ENV GOROOT="/usr/local/go"
ENV GOPATH="/go"
ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}

ENV PATH="$GOPATH/bin:/usr/local/go/bin:/osxcross/bin:$PATH"
ENV LD_LIBRARY_PATH="/osxcross/lib:$LD_LIBRARY_PATH"
COPY rootfs /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
