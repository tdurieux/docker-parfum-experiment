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

FROM openjdk_container

MAINTAINER AdoptOpenJDK <adoption-discuss@openjdk.java.net>

# Install required OS tools
RUN apt-get update \
    && apt-get install -qq -y --no-install-recommends \
       autoconf \
       ccache \
       cpio \
       file \
       g++-4.8 \
       gcc-4.8 \
       libdwarf-dev \
       libelf-dev \
       libfontconfig \
       libfreetype6-dev \
       libnuma-dev \
       pkg-config \
       ssh \
    && rm -rf /var/lib/apt/lists/*


# Make sure build uses 4.8
RUN rm /usr/bin/gcc \
    && rm /usr/bin/g++ \
    && rm /usr/bin/c++ \
    && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc \
    && ln -s /usr/bin/g++-4.8 /usr/bin/g++ \
    && ln -s /usr/bin/g++-4.8 /usr/bin/c++

ARG OPENJDK_VERSION
ENV OPENJDK_VERSION=$OPENJDK_VERSION
ENV JDK_PATH=jdk
