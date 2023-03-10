## Step 1: Build tests
FROM golang:1.9.4-alpine3.6 as builder

RUN apk add --no-cache --update \
    bash \
    btrfs-progs-dev \
    build-base \
    curl \
    lvm2-dev \
    jq \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /go/src/github.com/docker/docker/
WORKDIR /go/src/github.com/docker/docker/

# Generate frozen images
COPY contrib/download-frozen-image-v2.sh contrib/download-frozen-image-v2.sh
RUN contrib/download-frozen-image-v2.sh /output/docker-frozen-images \
	buildpack-deps:jessie@sha256:dd86dced7c9cd2a724e779730f0a53f93b7ef42228d4344b25ce9a42a1486251 \
	busybox:1.27-glibc@sha256:8c8f261a462eead45ab8e610d3e8f7a1e4fd1cd9bed5bc0a0c386784ab105d8e \
	debian:jessie@sha256:287a20c5f73087ab406e6b364833e3fb7b3ae63ca0eb3486555dc27ed32c6e60 \
	hello-world:latest@sha256:be0cd392e45be79ffeffa6b05338b98ebb16c87b255f48e297ec7f98e123905c

# Download Docker CLI binary
COPY hack/dockerfile hack/dockerfile
RUN hack/dockerfile/install.sh dockercli

# Set tag and add sources
ARG DOCKER_GITCOMMIT
ENV DOCKER_GITCOMMIT=$DOCKER_GITCOMMIT
ADD . .

# Build DockerSuite.TestBuild* dependency
RUN CGO_ENABLED=0 go build -buildmode=pie -o /output/httpserver github.com/docker/docker/contrib/httpserver

# Build the integration tests and copy the resulting binaries to /output/tests
RUN hack/make.sh build-integration-test-binary
RUN mkdir -p /output/tests && find . -name test.main -exec cp --parents '{}' /output/tests \;

## Step 2: Generate testing image
FROM alpine:3.6 as runner

# GNU tar is used for generating the emptyfs image
RUN apk add --no-cache --update \
    bash \
    ca-certificates \
    g++ \
    git \
    iptables \
    pigz \
    tar \
    xz \
    && rm -rf /var/cache/apk/*

# Add an unprivileged user to be used for tests which need it
RUN addgroup docker && adduser -D -G docker unprivilegeduser -s /bin/ash

COPY contrib/httpserver/Dockerfile /tests/contrib/httpserver/Dockerfile
COPY contrib/syscall-test /tests/contrib/syscall-test
COPY integration-cli/fixtures /tests/integration-cli/fixtures

COPY hack/test/e2e-run.sh /scripts/run.sh
COPY hack/make/.ensure-emptyfs /scripts/ensure-emptyfs.sh

COPY --from=builder /output/docker-frozen-images /docker-frozen-images
COPY --from=builder /output/httpserver /tests/contrib/httpserver/httpserver
COPY --from=builder /output/tests /tests
COPY --from=builder /usr/local/bin/docker /usr/bin/docker

ENV DOCKER_REMOTE_DAEMON=1 DOCKER_INTEGRATION_DAEMON_DEST=/

ENTRYPOINT ["/scripts/run.sh"]
