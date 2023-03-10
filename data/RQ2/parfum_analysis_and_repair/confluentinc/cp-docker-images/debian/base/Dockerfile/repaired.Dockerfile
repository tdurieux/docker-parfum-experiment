#
# Copyright 2016 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:jessie

ARG COMMIT_ID=unknown
LABEL io.confluent.docker.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL io.confluent.docker.build.number=$BUILD_NUMBER

ARG CONFLUENT_PACKAGES_REPO=$CONFLUENT_PACKAGES_REPO

ARG ALLOW_UNSIGNED=false
#Set an env var so that it's available in derived images
ENV ALLOW_UNSIGNED=$ALLOW_UNSIGNED

MAINTAINER partner-support@confluent.io
LABEL io.confluent.docker=true

# Python
ENV PYTHON_VERSION="2.7.9-1"
ENV PYTHON_PIP_VERSION="20.3.4"

# Confluent
ENV SCALA_VERSION="2.12"

ARG KAFKA_VERSION=$KAFKA_VERSION
ARG CONFLUENT_MAJOR_VERSION=$CONFLUENT_MAJOR_VERSION
ARG CONFLUENT_MINOR_VERSION=$CONFLUENT_MINOR_VERSION
ARG CONFLUENT_PATCH_VERSION=$CONFLUENT_PATCH_VERSION

ARG CONFLUENT_MVN_LABEL=$CONFLUENT_MVN_LABEL
ARG CONFLUENT_PLATFORM_LABEL=$CONFLUENT_PLATFORM_LABEL

ENV KAFKA_VERSION=$KAFKA_VERSION
ENV CONFLUENT_MAJOR_VERSION=$CONFLUENT_MAJOR_VERSION
ENV CONFLUENT_MINOR_VERSION=$CONFLUENT_MINOR_VERSION
ENV CONFLUENT_PATCH_VERSION=$CONFLUENT_PATCH_VERSION

ENV CONFLUENT_MVN_LABEL=$CONFLUENT_MVN_LABEL
ENV CONFLUENT_PLATFORM_LABEL=$CONFLUENT_PLATFORM_LABEL

ENV CONFLUENT_VERSION="$CONFLUENT_MAJOR_VERSION.$CONFLUENT_MINOR_VERSION.$CONFLUENT_PATCH_VERSION"
ENV CONFLUENT_DEB_VERSION="1"

# Zulu
ENV ZULU_OPENJDK_VERSION="8.0.302-1"

# This affects how strings in Java class files are interpreted.  We want UTF-8 and this is the only locale in the
# base image that supports it
ENV LANG="C.UTF-8"

RUN echo "===> Updating debian ....." \
    && apt-get -qq update \
    \
    && echo "===> Installing curl wget netcat python...." \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                apt-transport-https \
                software-properties-common \
                curl \
                gnupg-curl \
                git \
                wget \
                netcat \
                python=${PYTHON_VERSION} \
    && echo "===> Installing python packages ..." \
    && curl -fSL "https://bootstrap.pypa.io/pip/2.7/get-pip.py" | python \
    && pip install --no-cache-dir --upgrade pip==${PYTHON_PIP_VERSION} \
    && pip install --no-cache-dir git+https://github.com/confluentinc/confluent-docker-utils@v0.0.42-python2 \
    && apt remove --purge -y git \
    && echo "Installing Zulu OpenJDK ${ZULU_OPENJDK_VERSION}" \
    && rm /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt \
    && update-ca-certificates \
    && apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 0x27BC0C8CB3D81623F59BDADCB1998361219BD9C9 \
    && curl -f -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-2_all.deb \
    && dpkg --install zulu-repo_1.0.0-2_all.deb \
    && rm -f zulu-repo_1.0.0-2_all.deb \
    && apt-get update \
    && apt-get -y --no-install-recommends install "zulu8-ca-jdk-headless=${ZULU_OPENJDK_VERSION}" "zulu8-ca-jre-headless=${ZULU_OPENJDK_VERSION}" \
    && echo "===> Installing Kerberos Patch ..." \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install krb5-user \
    && rm -rf /var/lib/apt/lists/*

ENV CUB_CLASSPATH=/etc/confluent/docker/docker-utils.jar
COPY include/etc/confluent/docker /etc/confluent/docker
