# Copyright (c) 2019-2021, NVIDIA CORPORATION.  All rights reserved.
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

ARG BASE_DIST
ARG CUDA_VERSION
ARG GOLANG_VERSION=x.x.x
ARG VERSION="N/A"

# NOTE: In cases where the libc version is a concern, we would have to use an
# image based on the target OS to build the golang executables here -- especially
# if cgo code is included.
FROM golang:${GOLANG_VERSION} as build

# We override the GOPATH to ensure that the binaries are installed to
# /artifacts/bin
ARG GOPATH=/artifacts

# Install the experiemental nvidia-container-runtime
# NOTE: This will be integrated into the nvidia-container-toolkit package / repo
ARG NVIDIA_CONTAINER_RUNTIME_EXPERIMENTAL_VERSION=experimental
RUN GOPATH=/artifacts go install github.com/NVIDIA/nvidia-container-toolkit/cmd/nvidia-container-runtime.experimental@${NVIDIA_CONTAINER_RUNTIME_EXPERIMENTAL_VERSION}

WORKDIR /build
COPY . .

# NOTE: Until the config utilities are properly integrated into the
# nvidia-container-toolkit repository, these are built from the `tools` folder
# and not `cmd`.
RUN GOPATH=/artifacts go install -ldflags="-s -w -X 'main.Version=${VERSION}'" ./tools/...


FROM nvcr.io/nvidia/cuda:${CUDA_VERSION}-base-${BASE_DIST}

# Remove the CUDA repository configurations to avoid issues with rotated GPG keys
RUN rm -f /etc/apt/sources.list.d/cuda.list

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcap2 \
    curl \
        && \
    rm -rf /var/lib/apt/lists/*

ENV NVIDIA_DISABLE_REQUIRE="true"
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=utility

ARG ARTIFACTS_ROOT
ARG PACKAGE_DIST
COPY ${ARTIFACTS_ROOT}/${PACKAGE_DIST} /artifacts/packages/${PACKAGE_DIST}

WORKDIR /artifacts/packages

ARG PACKAGE_VERSION
ARG TARGETARCH
ENV PACKAGE_ARCH ${TARGETARCH}

ARG LIBNVIDIA_CONTAINER_REPO="https://nvidia.github.io/libnvidia-container"
ARG LIBNVIDIA_CONTAINER0_VERSION
RUN if [ "${PACKAGE_ARCH}" = "arm64" ]; then \
        curl -f -L ${LIBNVIDIA_CONTAINER_REPO}/${PACKAGE_DIST}/${PACKAGE_ARCH}/libnvidia-container0_${LIBNVIDIA_CONTAINER0_VERSION}_${PACKAGE_ARCH}.deb \
            --output ${PACKAGE_DIST}/${PACKAGE_ARCH}/libnvidia-container0_${LIBNVIDIA_CONTAINER0_VERSION}_${PACKAGE_ARCH}.deb && \
        dpkg -i ${PACKAGE_DIST}/${PACKAGE_ARCH}/libnvidia-container0_${LIBNVIDIA_CONTAINER0_VERSION}_${PACKAGE_ARCH}.deb; \
    fi

RUN dpkg -i \
    ${PACKAGE_DIST}/${PACKAGE_ARCH}/libnvidia-container1_1.*.deb \
    ${PACKAGE_DIST}/${PACKAGE_ARCH}/libnvidia-container-tools_1.*.deb \
    ${PACKAGE_DIST}/${PACKAGE_ARCH}/nvidia-container-toolkit_${PACKAGE_VERSION}*.deb

WORKDIR /work

COPY --from=build /artifacts/bin /work/

ENV PATH=/work:$PATH

LABEL io.k8s.display-name="NVIDIA Container Runtime Config"
LABEL name="NVIDIA Container Runtime Config"
LABEL vendor="NVIDIA"
LABEL version="${VERSION}"
LABEL release="N/A"
LABEL summary="Automatically Configure your Container Runtime for GPU support."
LABEL description="See summary"

RUN mkdir /licenses && mv /NGC-DL-CONTAINER-LICENSE /licenses/NGC-DL-CONTAINER-LICENSE

# Install / upgrade packages here that are required to resolve CVEs
ARG CVE_UPDATES
RUN if [ -n "${CVE_UPDATES}" ]; then \
        apt-get update && apt-get upgrade -y ${CVE_UPDATES} && \
        rm -rf /var/lib/apt/lists/*; \
    fi

ENTRYPOINT ["/work/nvidia-toolkit"]
