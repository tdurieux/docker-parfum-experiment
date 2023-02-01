# Copyright (c) 2018-2021 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

# Set up an Ubuntu image with 'blogbench' installed

# Usage: FROM [image name]
# hadolint ignore=DL3007
FROM @UBUNTU_REGISTRY@/ubuntu:latest

# Version of the Dockerfile
LABEL DOCKERFILE_VERSION="1.0"

# URL for blogbench test and blogbench version
ENV BLOGBENCH_URL "https://download.pureftpd.org/pub/blogbench"
ENV BLOGBENCH_VERSION 1.1

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential curl && \
	apt-get remove -y unattended-upgrades && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/ && \
	curl -f -OkL "${BLOGBENCH_URL}/blogbench-${BLOGBENCH_VERSION}.tar.gz" && \
	tar xzf "blogbench-${BLOGBENCH_VERSION}.tar.gz" -C / && rm "blogbench-${BLOGBENCH_VERSION}.tar.gz" && rm -rf /var/lib/apt/lists/*;
WORKDIR "/blogbench-${BLOGBENCH_VERSION}"
#	cd "blogbench-${BLOGBENCH_VERSION}" && \
RUN arch="$(uname -m)" && \
	export arch && \
	./configure --build="${arch}" && \
	make && \
	make install-strip

CMD ["/bin/bash"]
