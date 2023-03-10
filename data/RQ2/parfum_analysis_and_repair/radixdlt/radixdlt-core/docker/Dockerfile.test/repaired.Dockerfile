FROM ubuntu:20.04
MAINTAINER radixdlt <devops@radixdlt.com>
LABEL Description="Java + Ubuntu 16.04 (OpenJDK)"

ENV DEBIAN_FRONTEND noninteractive



CMD /bin/bash

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget curl iputils-ping dnsutils \
    unzip software-properties-common ca-certificates-java \
    docker.io && rm -rf /var/lib/apt/lists/*;
#install jdk11
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt update && \
    apt install --no-install-recommends -yq openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
#install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-6.6.1-bin.zip \
    && unzip gradle-6.6.1-bin.zip -d /opt \
    && rm gradle-6.6.1-bin.zip

# Set Gradle in the environment variables
ENV GRADLE_HOME=/opt/gradle-6.6.1
ENV PATH=/opt/gradle-6.6.1/bin:$PATH
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
RUN docker --version

COPY . /radixdlt-core
WORKDIR /radixdlt-core
USER root
CMD /bin/bash
