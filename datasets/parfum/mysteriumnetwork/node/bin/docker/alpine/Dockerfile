FROM golang:1.18-alpine AS builder

# Install packages
RUN apk add --no-cache git bash gcc musl-dev make linux-headers

ARG BUILD_BRANCH=$BUILD_BRANCH
ARG BUILD_COMMIT=$BUILD_COMMIT
ARG BUILD_NUMBER=$BUILD_NUMBER
ARG BUILD_VERSION=$BUILD_VERSION

# Compile application
WORKDIR /go/src/github.com/mysteriumnetwork/node
ADD go.mod go.sum ./
RUN go mod download
ADD . .
RUN bin/build


FROM alpine:3.14

# Install packages
RUN apk add --no-cache iptables ipset ca-certificates openvpn bash sudo openresolv

COPY bin/helpers/prepare-run-env.sh /usr/local/bin/prepare-run-env.sh
COPY bin/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

COPY bin/package/config/common /etc/mysterium-node
COPY bin/package/config/linux /etc/mysterium-node

COPY --from=builder /go/src/github.com/mysteriumnetwork/node/build/myst/myst /usr/bin/myst

WORKDIR /var/run/myst
