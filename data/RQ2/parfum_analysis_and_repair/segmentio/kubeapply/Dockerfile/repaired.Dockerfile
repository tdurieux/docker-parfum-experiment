# Fetch or build all required binaries
FROM golang:1.18 as builder

ARG VERSION_REF
RUN test -n "${VERSION_REF}"

ENV SRC github.com/segmentio/kubeapply

RUN apt-get update && apt-get install --no-install-recommends --yes \
    curl \
    wget && rm -rf /var/lib/apt/lists/*;

COPY . /go/src/${SRC}
RUN cd /usr/local/bin && /go/src/${SRC}/scripts/pull-deps.sh

WORKDIR /go/src/${SRC}

ENV CGO_ENABLED=1
ENV GO111MODULE=on

RUN make kubeapply VERSION_REF=${VERSION_REF} && \
    cp build/kubeapply /usr/local/bin

# Copy into final image
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends --yes \
    curl \
    git \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli

COPY --from=builder \
    /usr/local/bin/helm \
    /usr/local/bin/kubectl \
    /usr/local/bin/kubeapply \
    /usr/local/bin/
