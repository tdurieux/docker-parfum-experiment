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
ARG GOLANG_VERSION=undefined
FROM golang:${GOLANG_VERSION} AS go-build

# envs for packaging
ARG PACKAGE_NAME=undefined
ARG PACKAGE_VERSION=undefined
ARG PACKAGE_REVISION=undefined
ENV PACKAGE_NAME ${PACKAGE_NAME}
ENV PACKAGE_VERSION ${PACKAGE_VERSION}
ENV PACKAGE_REVISION ${PACKAGE_REVISION}

# destination to put tarball files
ENV DESTDIR=/${PACKAGE_NAME}-${PACKAGE_VERSION}-${PACKAGE_REVISION}

# working directory
WORKDIR /build
COPY . .

# collect tarball files
RUN mkdir -p ${DESTDIR}
RUN go build -o ${DESTDIR}/nvidia-mig-parted ./cmd
COPY ./LICENSE ${DESTDIR}
COPY ./deployments/systemd/packages/tarball/install.sh ${DESTDIR}
COPY ./deployments/systemd/config.yaml ${DESTDIR}
COPY ./deployments/systemd/hooks.sh ${DESTDIR}
COPY ./deployments/systemd/hooks-default.yaml ${DESTDIR}
COPY ./deployments/systemd/hooks-minimal.yaml ${DESTDIR}
COPY ./deployments/systemd/nvidia-mig-manager.service ${DESTDIR}
COPY ./deployments/systemd/nvidia-mig-parted.sh ${DESTDIR}
COPY ./deployments/systemd/override.conf ${DESTDIR}
COPY ./deployments/systemd/service.sh ${DESTDIR}
COPY ./deployments/systemd/uninstall.sh ${DESTDIR}
COPY ./deployments/systemd/utils.sh ${DESTDIR}

# output directory for final tarball
RUN mkdir -p /dist

# build command
WORKDIR /
CMD [ arch=$(uname -m) && \
    tar -zcvf /dist/${DESTDIR}.${arch}.tar.gz .${DESTDIR} && rm /dist/${DESTDIR}.${arch}.tar.gz]
