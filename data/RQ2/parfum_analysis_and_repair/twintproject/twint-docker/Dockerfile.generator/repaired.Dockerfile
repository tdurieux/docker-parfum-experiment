FROM golang:1.13-alpine AS builder

ARG TWINT_GENERATOR_VERSION=0.0.1

RUN apk add --no-cache make

COPY .  /go/src/github.com/x0rzkov/twint-docker
WORKDIR /go/src/github.com/x0rzkov/twint-docker

RUN cd /go/src/github.com/x0rzkov/twint-docker \
	&& go get -u github.com/go-bindata/go-bindata/... \
	&& go-bindata .docker/templates/... \
	&& cat bindata.go \
 	&& go build -v

FROM alpine:3.10 AS runtime

# Build argument
ARG VERSION=${VERSION:-"{{.Version}}"}
ARG BUILD
ARG NOW

# Install tini to /usr/local/sbin
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-muslc-amd64 /usr/local/sbin/tini

# Install runtime dependencies & create runtime user
RUN apk --no-cache --no-progress add ca-certificates \
 && chmod +x /usr/local/sbin/tini && mkdir -p /opt \
 && adduser -D x0rzkov -h /opt/twint-docker -s /bin/sh \
 && su x0rzkov -c 'cd /opt/twint-docker; mkdir -p bin config data'

# Switch to user context
USER x0rzkov
WORKDIR /opt/twint-docker/data

# Copy twint-docker binary to /opt/twint-docker/bin
COPY --from=builder /go/src/github.com/x0rzkov/twint-docker/twint-docker /opt/twint-docker/bin/twint-docker-gen
COPY x0rzkov.yml /opt/twint-docker/config/x0rzkov.yml
ENV PATH $PATH:/opt/twint-docker/bin

# Container metadata
LABEL name="twint" \
      version="$VERSION" \
      build="$BUILD" \
      architecture="x86_64" \
      build_date="$NOW" \
      vendor="twintproject" \
      maintainer="x0rzkov <x0rzkov@protonmail.com>" \
      url="https://github.com/twintproject/twint-docker" \
      summary="Dockerized twint project" \
      description="Dockerized twint project" \
      vcs-type="git" \
      vcs-url="https://github.com/twintproject/twint-docker" \
      vcs-ref="$VERSION" \
      distribution-scope="public"

# Container configuration
VOLUME ["/opt/twint-docker/data"]
ENTRYPOINT ["tini", "-g", "--"]
CMD ["/opt/twint-docker/bin/twint-docker-gen", "-config=/opt/twint-docker/config/x0rzkov.yml"]