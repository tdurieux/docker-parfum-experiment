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

# This Dockerfile in external/wycheproof/dockerfile dir is used to create an image with
# AdoptOpenJDK jdk binary installed. Basic test dependent executions
# are installed during the building process.
#
# Build example: `docker build -t adoptopenjdk-wycheproof -f Dockerfile ../.`
#
# This Dockerfile builds image based on adoptopenjdk/openjdk8:latest.
# If you want to build image based on other images, please use
# `--build-arg list` to specify your base image
#
# Build example: `docker build --build-arg IMAGE_NAME=<image_name> --build-arg IMAGE_VERSION=<image_version> -t adoptopenjdk-wycheproof .`

ARG SDK=openjdk8
ARG IMAGE_NAME=adoptopenjdk/$SDK
ARG IMAGE_VERSION=latest

FROM $IMAGE_NAME:$IMAGE_VERSION

# Install test dependent executable files
RUN apt-get update \
	&& apt-get -y install \
	ant \
	curl \
	git \
	unzip \
	zip \ 
	python \ 
	build-essential \ 
	wget

WORKDIR /
RUN mkdir testResults
ENV WYCHEPROOF_HOME $WORKDIR

ENV  JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

COPY ./dockerfile/wycheproof.sh /wycheproof.sh

#Install Bazel v0.14.0
RUN wget -q https://github.com/bazelbuild/bazel/releases/download/0.14.0/bazel-0.14.0-installer-linux-x86_64.sh
RUN chmod 755 $WYCHEPROOF_HOME/bazel-0.14.0-installer-linux-x86_64.sh
RUN $WYCHEPROOF_HOME/bazel-0.14.0-installer-linux-x86_64.sh

# Clone Wycheproof 
RUN pwd
RUN git clone https://github.com/google/wycheproof
#WORKDIR $WYCHEPROOF_HOME/wycheproof
#RUN git checkout 189df209602bda4262034a1e19e84b1fe4330fd8
#WORKDIR / 
ENTRYPOINT ["/bin/bash", "/wycheproof.sh"]
CMD [""]
