# Copyright (C) 2017-2018  Andrew Gunnerson <andrewgunnerson@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM registry.fedoraproject.org/fedora:29

# Install gosu
ENV GOSU_VERSION 1.10
RUN dnf -y install gnupg \
    && curl -f -Lo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -f -Lo /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver keyserver.ubuntu.com \
        --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /tmp/gosu.asc /usr/local/bin/gosu \
    && rm -r "${GNUPGHOME}" /tmp/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && dnf -y remove gnupg \
    && dnf clean all && rm -rf -d

# Install tini
ENV TINI_VERSION v0.16.1
RUN dnf -y install gnupg \
    && curl -f -Lo /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" \
    && curl -f -Lo /tmp/tini.asc "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver keyserver.ubuntu.com \
        --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
    && gpg --batch --verify /tmp/tini.asc /usr/local/bin/tini \
    && rm -r "${GNUPGHOME}" /tmp/tini.asc \
    && chmod +x /usr/local/bin/tini \
    && dnf -y remove gnupg \
    && dnf clean all && rm -rf -d

# Install Android NDK
ARG ANDROID_NDK_VERSION=r18b
ARG ANDROID_NDK_CHECKSUM=500679655da3a86aecf67007e8ab230ea9b4dd7b
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK ${ANDROID_NDK_HOME}

RUN parent=$(dirname ${ANDROID_NDK_HOME}) \
    && mkdir -p ${parent} \
    && cd ${parent} \
    && dnf install -y aria2 unzip \
    && aria2c -x4 https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
        --check-integrity --checksum sha-1=${ANDROID_NDK_CHECKSUM} \
    && unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
    && rm android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
    && mv android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} \
    && dnf remove -y aria2 unzip \
    && dnf clean all

# Set up path
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

# Install dependencies
# procps-ng is needed due to https://issues.jenkins-ci.org/browse/JENKINS-40101
RUN dnf -y install \
        ccache cmake findutils gcc-c++ git make procps-ng unzip zip \
        ncurses-compat-libs \
        java-1.8.0-openjdk-headless transifex-client \
        openssl-devel yaml-cpp-devel \
        qemu-system-aarch64-core qemu-system-arm-core qemu-system-x86-core \
    && dnf clean all

# Volumes
ENV BUILDER_HOME /builder
RUN mkdir -m 0700 ${BUILDER_HOME}
WORKDIR ${BUILDER_HOME}

# Entrypoint
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
