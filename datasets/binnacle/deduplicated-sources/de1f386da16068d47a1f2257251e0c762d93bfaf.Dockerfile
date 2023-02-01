# Docker image for building our IdP server (not run in kubernetes--see
# Dockerfile.idp for that)
#
# Building in alpine instead of ubuntu (or whatever other distro the host
# machine is running) allows us to link the SAML IdP with the musl libc
# implementaion instead of glibc.  This allows us to compile the IdP server
# into a completely static binary even though it calls the libc function
# getaddrinfo() (via Go's "net" library).
#
# Also note: this is a separate Dockerfile from the one used to create the
# image (Dockerfile.idp) because we need to mount ../vendor into the container
# as part of the build process, and there's no way to mount an external
# directory into a docker container as part of 'docker build'
FROM golang:1.10.2-alpine AS build
LABEL maintainer="msteffen@pachyderm.io"

# Add libc so we can build with it (saml-idp uses getaddrinfo)
RUN apk update
RUN apk add git gcc libc-dev

# Add saml-idp source to container
RUN mkdir -p /go/src/saml-idp
ADD ./*.go /go/src/saml-idp

# Build saml-id (quote -ldflags arguments)
CMD go install -ldflags "-linkmode external -extldflags -static" -a saml-idp \
  && chmod 755 /go/bin/saml-idp \
  && cp /go/bin/saml-idp /out
