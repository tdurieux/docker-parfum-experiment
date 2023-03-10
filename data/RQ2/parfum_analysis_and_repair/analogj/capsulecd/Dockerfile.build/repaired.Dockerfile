###############################################################################
#
# This Dockerfile should only be used to cross-compile capsulecd for various
# OS's and Architectures. Its massive, and should not be used as a base image
# for your Dockerfiles.
#
# Usable Docker Images and Dockerfiles for different languages are located:
# - https://github.com/AnalogJ/capsulecd-docker
# - https://hub.docker.com/r/analogj/capsulecd
#
# Use `docker pull analogj/capsulecd:<language>`
#
###############################################################################
FROM analogj/libgit2-xgo
MAINTAINER Jason Kulatunga <jason@thesparktree.com>

WORKDIR /go/src/github.com/analogj/capsulecd

ENV PATH="/go/src/github.com/analogj/capsulecd:/go/bin:${PATH}" \
	SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Install build tooling.
RUN echo "go version: \
    && go version \
    && apt-get update \
	&& apt-get install -y gcc git build-essential binutils curl apt-transport-https ca-certificates pkg-config --no-install-recommends \
	&& rm -rf /usr/share/doc && rm -rf /usr/share/man \
	&& rm -rf /var/lib/apt/lists/* \
    && apt-get clean


ENV PATH="/go/bin:/usr/local/go/bin:${PATH}" \
	GOPATH="/go:${GOPATH}" \
	SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# ensure go is configured correctly