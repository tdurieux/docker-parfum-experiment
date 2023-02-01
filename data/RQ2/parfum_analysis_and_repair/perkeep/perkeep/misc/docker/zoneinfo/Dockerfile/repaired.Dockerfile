# Copyright 2016 The Perkeep Authors.

FROM debian:stable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
