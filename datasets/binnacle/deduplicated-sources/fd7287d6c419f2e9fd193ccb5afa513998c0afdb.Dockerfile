FROM node:alpine

MAINTAINER Waldemar Hummer (whummer@atlassian.com)
LABEL authors="Waldemar Hummer (whummer@atlassian.com)"

# install some common libs
RUN apk add --no-cache autoconf automake build-base ca-certificates curl docker git \
        libffi-dev libtool linux-headers make openssl openssl-dev python python-dev \
        py-pip supervisor tar xz zip && \
    update-ca-certificates

# Install Java - taken from official repo:
# https://github.com/docker-library/openjdk/blob/master/8-jdk/alpine/Dockerfile)
ENV LANG C.UTF-8
RUN { \
        echo '#!/bin/sh'; echo 'set -e'; echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u131
ENV JAVA_ALPINE_VERSION 8.131.11-r2
RUN set -x && apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]


# Install Maven - taken from official repo:
# https://github.com/carlossg/docker-maven/blob/master/jdk-8/Dockerfile)
ARG MAVEN_VERSION=3.5.0
ARG USER_HOME_DIR="/root"
ARG SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ADD https://raw.githubusercontent.com/carlossg/docker-maven/master/jdk-8/settings-docker.xml /usr/share/maven/ref/

# set workdir
RUN mkdir -p /opt/code/localstack
WORKDIR /opt/code/localstack/

# init environment and cache some dependencies
ADD requirements.txt .
RUN wget -O /tmp/localstack.es.zip \
        https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.zip && \
    (pip install --upgrade pip) && \
    (test `which virtualenv` || \
        pip install virtualenv || \
        sudo pip install virtualenv) && \
    (virtualenv .testvenv && \
        source .testvenv/bin/activate && \
        pip install six==1.10.0 && \
        pip install --quiet -r requirements.txt && \
        rm -rf .testvenv)

# add files required to run "make install-web"
ADD Makefile .
ADD localstack/dashboard/web/package.json localstack/dashboard/web/package.json

# install web dashboard dependencies
RUN make install-web

# cache Maven dependencies
ADD localstack/ext/java/pom.xml localstack/ext/java/pom.xml
RUN cd localstack/ext/java && mvn -q -DskipTests package || true
