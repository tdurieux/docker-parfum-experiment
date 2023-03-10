ARG GO_VERSION=1.10.3
# Use Debian based image as docker-compose requires glibc.
FROM golang:${GO_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    openssl \
    && rm -rf /var/lib/apt/lists/*

ARG COMPOSE_VERSION=1.21.2
RUN curl -f -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

ARG NOTARY_VERSION=v0.6.1
RUN curl -f -Ls https://github.com/theupdateframework/notary/releases/download/${NOTARY_VERSION}/notary-Linux-amd64 -o /usr/local/bin/notary \
    && chmod +x /usr/local/bin/notary

ENV CGO_ENABLED=0 \
    DISABLE_WARN_OUTSIDE_CONTAINER=1 \
    PATH=/go/src/github.com/docker/cli/build:$PATH
WORKDIR /go/src/github.com/docker/cli

# Trust notary CA cert.
COPY e2e/testdata/notary/root-ca.cert /usr/share/ca-certificates/notary.cert
RUN echo 'notary.cert' >> /etc/ca-certificates.conf && update-ca-certificates

COPY . .
ARG VERSION
ARG GITCOMMIT
ENV VERSION=${VERSION} GITCOMMIT=${GITCOMMIT}
RUN ./scripts/build/binary

CMD ./scripts/test/e2e/entry
