# Copyright 2016 The WWU eLectures Team All rights reserved.
#
# Licensed under the Educational Community License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM docker.io/maven:3-jdk-11-slim
LABEL org.opencontainers.image.base.name="docker.io/maven:3-jdk-11-slim"

ARG OPENCAST_REPO="https://github.com/opencast/opencast.git"
ARG OPENCAST_VERSION="develop"
ARG FFMPEG_VERSION="latest"
ARG VERSION=unkown
ARG BUILD_DATE=unkown
ARG GIT_COMMIT=unkown

LABEL maintainer="educast.nrw <info@educast.nrw>" \
      org.opencontainers.image.title="opencast-build" \
      org.opencontainers.image.description="container image that provides an Opencast build and development environment" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.vendor="Opencast" \
      org.opencontainers.image.authors="educast.nrw <info@educast.nrw>" \
      org.opencontainers.image.licenses="ECL-2.0" \
      org.opencontainers.image.url="https://github.com/opencast/opencast-docker/blob/${VERSION}/README.md" \
      org.opencontainers.image.documentation="https://github.com/opencast/opencast-docker/blob/${VERSION}/README.md" \
      org.opencontainers.image.source="https://github.com/opencast/opencast-docker" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${GIT_COMMIT}"

ENV OPENCAST_REPO="${OPENCAST_REPO}" \
    OPENCAST_VERSION="${OPENCAST_VERSION}" \
    OPENCAST_DISTRIBUTION="${OPENCAST_DISTRIBUTION}" \
    OPENCAST_SRC="/usr/src/opencast" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_DATA="/data" \
    OPENCAST_CUSTOM_CONFIG="/etc/opencast" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UHOME="/home/opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_BUILD_ASSETS="/docker"
ENV OPENCAST_CONFIG="${OPENCAST_HOME}/etc" \
    OPENCAST_SCRIPTS="${OPENCAST_HOME}/docker/scripts" \
    OPENCAST_SUPPORT="${OPENCAST_HOME}/docker/support" \
    OPENCAST_STAGE_BASE_HOME="${OPENCAST_HOME}/docker/stage/base" \
    OPENCAST_STAGE_OUT_HOME="${OPENCAST_HOME}/docker/stage/out"
ENV ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER="admin" \
    ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS="opencast" \
    ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER="opencast_system_account" \
    ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS="CHANGE_ME"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      firefox-esr \
      g++ \
      gcc \
      git \
      gzip \
      libc-dev \
      make \
      openssl \
      sudo \
      tar \
      xz-utils \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      fontconfig \
      fonts-dejavu \
      fonts-freefont-ttf \
      fonts-liberation \
      fonts-linuxlibertine \
      hunspell \
      hunspell-en-au \
      hunspell-en-ca \
      hunspell-en-gb \
      hunspell-en-us \
      hunspell-en-za \
      inotify-tools \
      jq \
      netcat-openbsd \
      nfs-common \
      openssl \
      rsync \
      sox \
      synfig \
      tesseract-ocr \
      tesseract-ocr-eng \
      tzdata \
  \
 && sudo ln -s /usr/local/openjdk*/bin/* /usr/local/bin/ \
  \
 && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
 && cd /tmp/su-exec \
 && make \
 && cp su-exec /usr/local/sbin \
  \
 && mkdir -p /tmp/ffmpeg \
 && cd /tmp/ffmpeg \
 && curl -f -sSL "https://s3.opencast.org/opencast-ffmpeg-static/ffmpeg-${FFMPEG_VERSION}.tar.xz" \
     | tar xJf - --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe' \
 && chown root:root ff* \
 && mv ff* /usr/local/bin \

 && groupadd --system -g "${OPENCAST_GID}" "${OPENCAST_GROUP}" \
 && useradd --system -M -N -g "${OPENCAST_GROUP}" -d "${OPENCAST_UHOME}" -u "${OPENCAST_UID}" "${OPENCAST_USER}" \
 && mkdir -p "${OPENCAST_SRC}" "${OPENCAST_HOME}" "${OPENCAST_UHOME}" "${OPENCAST_DATA}" "${OPENCAST_BUILD_ASSETS}" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" "${OPENCAST_UHOME}" "${OPENCAST_DATA}" \
 && echo "opencast-builder ALL = NOPASSWD: ALL" > /etc/sudoers.d/opencast-builder \

 && cd / \
 && rm -rf /tmp/* /var/lib/apt/lists/*

COPY rootfs       "${OPENCAST_BUILD_ASSETS}/"
COPY rootfs-build /

WORKDIR "${OPENCAST_SRC}"

EXPOSE 8080 5005
VOLUME [ "${OPENCAST_DATA}", "${OPENCAST_SRC}", "/root/.m2" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]
