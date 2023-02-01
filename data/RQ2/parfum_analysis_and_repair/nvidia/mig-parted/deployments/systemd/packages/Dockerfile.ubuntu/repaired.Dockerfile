# Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# build go binary
ARG BASE_IMAGE=undefined
ARG GOLANG_VERSION=undefined
FROM golang:${GOLANG_VERSION} AS go-build

WORKDIR /build
COPY . .
RUN go build -o /artifacts/nvidia-mig-parted ./cmd

# build package
FROM ${BASE_IMAGE}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y devscripts debhelper && rm -rf /var/lib/apt/lists/*;

# envs for packaging
ARG PACKAGE_NAME=undefined
ARG PACKAGE_VERSION=undefined
ARG PACKAGE_REVISION=undefined
ENV PACKAGE_NAME ${PACKAGE_NAME}
ENV PACKAGE_VERSION ${PACKAGE_VERSION}
ENV PACKAGE_REVISION ${PACKAGE_REVISION}
ENV SECTION ""

# working directory
ENV PWD=/tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}
WORKDIR ${PWD}

# sources
COPY ./LICENSE .
COPY --from=go-build /artifacts/nvidia-mig-parted .
COPY ./deployments/systemd .
COPY ./deployments/systemd/packages/debian ./debian
COPY ./deployments/systemd/packages/debian/Makefile .

# output directory
RUN mkdir -p /dist

# Check that the latest changelog entry matches the current version info
RUN if [ "${PACKAGE_VERSION}-${PACKAGE_REVISION}" != "$(dpkg-parsechangelog --show-field=Version)" ]; then exit 1; fi

# build command
CMD export DISTRIB=$(lsb_release -c -s) && \
    debuild -eDISTRIB -eSECTION \
        --dpkg-buildpackage-hook='sh debian/prepare' -i -us -uc -b && \
    mv /tmp/*.deb /dist
