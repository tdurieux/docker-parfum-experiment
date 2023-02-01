FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gfortran \
    git \
    liblapack-dev \
    pkgconf && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
