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

# This Dockerfile in external/openliberty-mp-tck/dockerfile dir is used to create an image with
# AdoptOpenJDK jdk binary installed. Basic test dependent executions
# are installed during the building process.
#
# Build example: `docker build -t adoptopenjdk-openliberty-mp-tck -f Dockerfile ../.`
#
# This Dockerfile builds image based on adoptopenjdk/openjdk8:latest.
# If you want to build image based on other images, please use
# `--build-arg list` to specify your base image
#
# Build example: `docker build --build-arg IMAGE_NAME=<image_name> --build-arg IMAGE_VERSION=<image_version> -t adoptopenjdk-openliberty-mp-tck .`

ARG SDK=openjdk8
ARG IMAGE_NAME=adoptopenjdk/$SDK
ARG IMAGE_VERSION=latest

FROM $IMAGE_NAME:$IMAGE_VERSION

# Install test dependent executable files
RUN apt-get update \
	&& apt-get -y install \
	ant \
	apt-transport-https \
	ca-certificates \
	dirmngr \
	curl \
	git \
	unzip \
	wget
	
# Install openliberty-mp-tck tests dependent
RUN apt-get update \
	&& apt-get -y install \
	maven


WORKDIR /
ENV OPENLIBERTY_HOME $WORKDIR
RUN mkdir testResults

ENV  JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

COPY ./dockerfile/openliberty-mp-tck.sh /openliberty-mp-tck.sh

#Clone openliberty repo 
RUN git clone -q git://github.com/OpenLiberty/open-liberty

ENTRYPOINT ["/bin/bash", "/openliberty-mp-tck.sh"]
CMD [""]
