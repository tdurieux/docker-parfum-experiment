# This Dockerfile builds the psycopg2 wheel
# Inputs:
#    - PSYCOPG2_GIT_TAG - The Git tag to clone and build from
#    - PSYCOPG2_VERSION - Unused, kept for future possible usage

FROM python:3.9-slim-bullseye as main

LABEL org.opencontainers.image.description="A intermediate image with psycopg2 wheel built"

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_PACKAGES="\
  build-essential \
  git \
  python3-dev \
  python3-pip \
  # https://www.psycopg.org/docs/install.html#prerequisites
  libpq-dev"

WORKDIR /usr/src

# As this is an base image for a multi-stage final image
# the added size of the install is basically irrelevant

RUN set -eux \
  && apt-get update --quiet \
  && apt-get install --yes --quiet --no-install-recommends $BUILD_PACKAGES \
  && rm -rf /var/lib/apt/lists/* \
  && python3 -m pip install --no-cache-dir --upgrade pip wheel

# Layers after this point change according to required version
# For better caching, seperate the basic installs from
# the building