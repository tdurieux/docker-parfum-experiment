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

# This Dockerfile in external/derby/dockerfile dir is used to create an image with
# AdoptOpenJDK jdk binary installed. Basic test dependent executions
# are installed during the building process.
#
# Build example: `docker build -t adoptopenjdk-derby-test -f Dockerfile ../.`
#
# This Dockerfile builds image based on adoptopenjdk/openjdk8:latest.
# If you want to build image based on other images, please use
# `--build-arg list` to specify your base image
#
# Build example: `docker build --build-arg IMAGE_NAME=<image_name> --build-arg IMAGE_VERSION=<image_version >-t adoptopenjdk-derby-test .`

ARG SDK=openjdk8
ARG IMAGE_NAME=adoptopenjdk/$SDK
ARG IMAGE_VERSION=latest

FROM $IMAGE_NAME:$IMAGE_VERSION

# Install test dependent executable files
RUN apt-get update \
	&& apt-get -y install \
	apt-transport-https \
	ca-certificates \
	dirmngr \
	curl \
	git \
	make \
	unzip \
	vim \
	tar \
	wget \
	ant

ENV  JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

WORKDIR /
ENV DERBY_HOME ${WORKDIR}/derby

# This is the main script to run derby tests.
COPY ./dockerfile/derby-test.sh /derby-test.sh

# Clone Derby source.
RUN git clone https://github.com/apache/derby.git 

ENTRYPOINT ["/bin/bash", "/derby-test.sh"]
CMD ["--version"]
