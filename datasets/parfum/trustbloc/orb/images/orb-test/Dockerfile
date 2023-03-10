#
# Copyright SecureKey Technologies Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

ARG GO_VER
ARG ALPINE_VER
ARG BUILDPLATFORM

FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:${GO_VER}-alpine${ALPINE_VER} as builder

RUN apk update && apk add git && apk add ca-certificates
RUN apk add --no-cache \
 	gcc \
 	musl-dev \
 	git \
 	libtool \
 	bash \
 	make;

RUN adduser -D -g '' appuser
COPY . $GOPATH/src/github.com/trustbloc/orb/
WORKDIR $GOPATH/src/github.com/trustbloc/orb/

ARG TARGETOS
ARG TARGETARCH
ARG GO_TAGS
ARG GO_LDFLAGS
ARG GOPROXY

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GO_TAGS=testver GO_LDFLAGS=${GO_LDFLAGS} GOPROXY=${GOPROXY} make orb-test

FROM scratch

LABEL org.opencontainers.image.source https://github.com/trustbloc/orb-test

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/src/github.com/trustbloc/orb/.build/bin/orb-test /usr/bin/orb
USER appuser

ENTRYPOINT ["/usr/bin/orb"]
