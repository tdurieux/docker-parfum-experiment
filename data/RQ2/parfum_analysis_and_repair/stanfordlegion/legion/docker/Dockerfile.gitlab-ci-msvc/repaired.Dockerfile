# Build Image for Gitlab CI - limited msvc compilation capability

FROM madduci/docker-wine-msvc:16.9-2019
USER root
ENTRYPOINT /bin/bash

MAINTAINER Sean Treichler <sean@nvidia.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq apt-transport-https ca-certificates software-properties-common wget git vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
