# Copyright (c) 2020-2021 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

# Set up an Ubuntu image with 'web tooling' installed

# Usage: FROM [image name]
# hadolint ignore=DL3007
FROM @UBUNTU_REGISTRY@/ubuntu:latest

# Version of the Dockerfile
LABEL DOCKERFILE_VERSION="1.0"

# URL for web tooling test
ENV WEB_TOOLING_URL "https://github.com/v8/web-tooling-benchmark"
ENV NODEJS_VERSION "setup_14.x"

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential git curl sudo && \
	apt-get remove -y unattended-upgrades && \
	curl -f -OkL https://deb.nodesource.com/${NODEJS_VERSION} && chmod +x ${NODEJS_VERSION} && ./${NODEJS_VERSION} && \
	apt-get install -y --no-install-recommends nodejs && \
	apt-get clean && rm -rf /var/lib/apt/lists && \
	git clone ${WEB_TOOLING_URL} /web-tooling-benchmark && rm -rf /var/lib/apt/lists/*;
WORKDIR /web-tooling-benchmark/
RUN npm install --unsafe-perm && npm cache clean --force;

CMD ["/bin/bash"]
