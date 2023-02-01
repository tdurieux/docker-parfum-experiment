# Copyright (c) 2018-present, GM Cruise LLC
#
# This source code is licensed under the Apache License, Version 2.0,
# found in the LICENSE file in the root directory of this source tree.
# You may not use this file except in compliance with the License.

# This is just for use in CI, as well as the base image for our proprietary version.
# This container is published at https://hub.docker.com/r/cruise/webviz-ci.

FROM node:16.13.2-slim

# Install some general dependencies for stuff below and for CircleCI;
# https://circleci.com/docs/2.0/custom-images/#required-tools-for-primary-containers
RUN apt-get update && apt-get install -yq gnupg libgconf-2-4 wget git ssh --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Install Google Chrome for Puppeteer.
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker
RUN wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf --no-install-recommends && rm -rf /var/lib/apt/lists/*;
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install rust-specific libraries
RUN apt update
RUN apt -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN git clone https://github.com/plaurent/gnustep-build && gnustep-build/debian-10-clang-8.0/GNUstep-buildon-debian10.sh
RUN apt install --no-install-recommends -y libatk1.0-0 libatk-bridge2.0-0 libxkbcommon0 && rm -rf /var/lib/apt/lists/*;

# Install rust build tools
RUN set -eux; \
    wget -O - https://sh.rustup.rs > rustup-init.sh; \
    sh rustup-init.sh -y;
ENV PATH /root/.cargo/bin:$PATH

RUN rustup --version; \
    cargo --version; \
    rustc --version;

ENV WEBVIZ_IN_DOCKER=true

# Bumped up from the default old_space size (512mb) as it was being exceeded during builds.
ENV NODE_OPTIONS="--max_old_space_size=4096"
