FROM ubuntu:22.04 AS apt-cache
RUN apt-get update

FROM ubuntu:22.04 AS base
ENV DEBIAN_FRONTEND noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install --no-install-recommends -y -qq build-essential ca-certificates curl git unzip && rm -rf /var/lib/apt/lists/*;

FROM base AS builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get install --no-install-recommends -y -qq haskell-platform && rm -rf /var/lib/apt/lists/*;
COPY build.sh /
