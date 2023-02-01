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

# This Dockerfile in external/lucene-solr/dockerfile dir is used to create an image with
# AdoptOpenJDK jdk binary installed. Basic test dependent executions
# are installed during the building process.
#
# Build example: `docker build -t adoptopenjdk-lucene-solr-test -f Dockerfile ../.`
#
# This Dockerfile builds image based on adoptopenjdk/openjdk8:latest.
# If you want to build image based on other images, please use
# `--build-arg list` to specify your base image
#
# Build example: `docker build --build-arg IMAGE_NAME=<image_name> --build-arg IMAGE_VERSION=<image_version> -t adoptopenjdk-lucene-solr-test .`

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
	wget

WORKDIR /
ENV LUCENE_SOLR_HOME ${WORKDIR}

#apache ant setup 
ENV ANT_VERSION 1.10.3
RUN wget --no-check-certificate --no-cookies https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    gunzip apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xvf apache-ant-${ANT_VERSION}-bin.tar

#apache ivy setup 
ENV IVY_VERSION 2.4.0
RUN wget --no-check-certificate --no-cookies https://archive.apache.org/dist/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz && \
    gunzip apache-ivy-${IVY_VERSION}-bin.tar.gz && \
    tar -xvf apache-ivy-${IVY_VERSION}-bin.tar && \
    cp apache-ivy-${IVY_VERSION}/ivy-${IVY_VERSION}.jar $WORKDIR/apache-ant-${ANT_VERSION}/lib/
ENV ANT_HOME ${WORKDIR}/apache-ant-${ANT_VERSION}

ENV  JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

COPY ./dockerfile/lucene-solr-test.sh /lucene-solr-test.sh

# Clone the repo where the Lucen-Solr code and tests reside.

#default is HEAD
RUN git clone https://github.com/apache/lucene-solr.git
ARG LUCENE_SOLR_TAG=.
WORKDIR lucene-solr
RUN git checkout -q $LUCENE_SOLR_TAG

ENTRYPOINT ["/bin/bash", "/lucene-solr-test.sh"]
CMD ["--version"]
