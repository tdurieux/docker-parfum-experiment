FROM debian:8
MAINTAINER Insight Software Consortium <community@itk.org>

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  ninja-build \
  git && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/KWStyle-build && rm -rf /usr/src/KWStyle-build
WORKDIR /usr/src


