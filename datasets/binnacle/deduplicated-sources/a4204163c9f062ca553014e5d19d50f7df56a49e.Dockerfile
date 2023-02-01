# (C) Copyright IBM Corporation 2017.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

MAINTAINER AdoptOpenJDK <adoption-discuss@openjdk.java.net>

# Install required OS tools.  Yes we have to apt-get update first in order to
# get to software-properties-common, which includes the apt-add-repository
# package, so we can add the Azul repo and then apt-get update that so we cam
# get zulu-7.  This is why we can't have nice things.
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 \
  && apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main' \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -qq -y --no-install-recommends \
    ccache \
    cpio \
    curl \
    file \
    g++ \
    gcc \
    git \
    libasound2-dev \
    libcups2-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxt-dev \
    libxtst-dev \
    make \
    unzip \
    wget \
    zip \
    zulu-7 \
    ssh \
&& rm -rf /var/lib/apt/lists/*

# Pick up build instructions
RUN mkdir -p /openjdk/target

COPY sbin /openjdk/sbin
COPY workspace/config /openjdk/config

RUN mkdir -p /openjdk/build
RUN useradd -ms /bin/bash build
RUN chown -R build: /openjdk/
USER build
WORKDIR /openjdk/build/

# Default actions
ENTRYPOINT ["/openjdk/sbin/build.sh"]

CMD ["images"]

ARG OPENJDK_CORE_VERSION
ENV OPENJDK_CORE_VERSION=$OPENJDK_CORE_VERSION
ENV JDK_PATH=j2sdk-image
ENV JRE_PATH=j2re-image
