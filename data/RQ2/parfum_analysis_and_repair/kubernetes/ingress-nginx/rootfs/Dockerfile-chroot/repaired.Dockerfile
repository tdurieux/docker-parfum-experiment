# Copyright 2022 The Kubernetes Authors. All rights reserved.
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
# limitations under the License

ARG BASE_IMAGE

FROM ${BASE_IMAGE} as chroot

# This intermediary image will be used only to copy all the required files to the chroot
# TODO: Simplify in a future to a single Dockerfile
COPY chroot.sh /chroot.sh
RUN apk update \
  && apk upgrade \
  && /chroot.sh

FROM alpine:3.16.0

ARG TARGETARCH
ARG VERSION
ARG COMMIT_SHA
ARG BUILD_ID=UNSET

LABEL org.opencontainers.image.title="NGINX Ingress Controller for Kubernetes"
LABEL org.opencontainers.image.documentation="https://kubernetes.github.io/ingress-nginx/"
LABEL org.opencontainers.image.source="https://github.com/kubernetes/ingress-nginx"
LABEL org.opencontainers.image.vendor="The Kubernetes Authors"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.revision="${COMMIT_SHA}"

LABEL build_id="${BUILD_ID}"

# This will be injected in the chroot. Don't change :)
ENV LUA_PATH="/usr/local/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/?/?.so;/usr/local/lib/lua/?.so;;"
ENV PATH=$PATH:/usr/local/luajit/bin:/usr/local/nginx/sbin:/usr/local/nginx/bin

RUN apk update \
  && apk upgrade \
  && apk add -U --no-cache \
     bash \
     curl \
     openssl \
     ca-certificates \
     dumb-init \
     tzdata \
     diffutils \
     util-linux \
  && ln -s /usr/local/nginx/sbin/nginx /sbin/nginx \
  && adduser -S -D -H -u 101 -h /usr/local/nginx \
    -s /sbin/nologin -G www-data -g www-data www-data 

COPY --from=chroot /chroot /chroot

COPY --chown=www-data:www-data etc /chroot/etc

COPY --chown=www-data:www-data bin/${TARGETARCH}/dbg /
COPY --chown=www-data:www-data bin/${TARGETARCH}/nginx-ingress-controller /
COPY --chown=www-data:www-data bin/${TARGETARCH}/wait-shutdown /
COPY --chown=www-data:www-data nginx-chroot-wrapper.sh /usr/bin/nginx

WORKDIR /chroot/etc/nginx

# Fix permission during the build to avoid issues at runtime
# with volumes (custom templates)
RUN bash -xeu -c ' \
  writeDirs=( \
    /var/log \
  ); \
  for dir in "${writeDirs[@]}"; do \
    mkdir -p ${dir}; \
    chown -R www-data.www-data ${dir}; \
  done' \
  # LD_LIBRARY_PATH does not work so below is needed for  opentelemetry/other modules
  # Put libs of newer modules under `/modules_mount/<other>/lib` and add that path below
  # Could get complicated arch specific paths become a need