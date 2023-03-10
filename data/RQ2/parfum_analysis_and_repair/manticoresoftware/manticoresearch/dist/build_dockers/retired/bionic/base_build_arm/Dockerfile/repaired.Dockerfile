FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    libmysqlclient-dev \
    libexpat-dev \
    libpq-dev \
    unixodbc-dev \
    flex \
    bison \
    git \
    build-essential \
    libjemalloc-dev \
    libssl-dev \
    wget \
&& rm -rf /var/lib/apt/lists/*

ENV DISTR bionic
CMD []

# docker build -t base_build_arm:bionic .