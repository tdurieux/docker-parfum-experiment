# Dockerfile for STAR
#
ARG ALPINE_VER=3.11
FROM alpine:${ALPINE_VER} AS builder

ARG STAR_VER=2.4.0j

ENV _STAR_VERSION ${STAR_VER}

RUN apk update &&\
    apk --no-cache add curl

RUN mkdir -p build/STAR && curl -L https://api.github.com/repos/alexdobin/STAR/tarball/STAR_$_STAR_VERSION | \
    tar xz --strip-components=1 -C build/STAR

FROM grapenf/base

LABEL author.name="Emilio Palumbo"
LABEL author.email="emiliopalumbo@gmail.com"

COPY --from=builder /build/STAR/bin/Linux_x86_64_static/STAR /usr/local/bin/
