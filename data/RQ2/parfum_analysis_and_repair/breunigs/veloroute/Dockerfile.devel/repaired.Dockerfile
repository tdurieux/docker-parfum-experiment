# syntax=docker/dockerfile:experimental

ARG ELIXIR_VERSION
ARG ERLANG_VERSION
ARG ALPINE_VERSION

FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} AS base
ENTRYPOINT [ "mix" ]
ENV GIT_COMMIT="dockerfile dummy"

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
RUN apk add --no-cache build-base optipng inkscape nodejs npm brotli git ffmpeg glibc-2.34-r0.apk

WORKDIR /build
ARG UID=1000
ARG GID=1000

ENV MIX_HOME=/mix
RUN mkdir /mix && chmod og+rw /mix

RUN addgroup --gid $GID fakeuser && \
  adduser \
  --disabled-password \
  --gecos "" \
  --ingroup fakeuser \
  --home /build \
  --uid $UID \
  fakeuser

USER $UID:$GID

RUN \
  mix local.hex --force && \
  mix local.rebar --force