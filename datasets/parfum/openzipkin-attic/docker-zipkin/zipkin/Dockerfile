#
# Copyright 2015-2016 The OpenZipkin Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
#

FROM alpine

ENV ZIPKIN_REPO https://repo1.maven.org/maven2
ENV ZIPKIN_VERSION 2.18.2

# Add environment settings for supported storage types
COPY zipkin/ /zipkin/
WORKDIR /zipkin

RUN apk add unzip curl --no-cache && \
    curl -SL $ZIPKIN_REPO/io/zipkin/zipkin-server/$ZIPKIN_VERSION/zipkin-server-$ZIPKIN_VERSION-exec.jar > zipkin-server.jar && \
    # don't break when unzip finds an extra header https://github.com/openzipkin/zipkin/issues/1932
    unzip zipkin-server.jar ; \
    rm zipkin-server.jar && \
    # statically evaluate classpath to avoid https://github.com/docker/for-mac/issues/3643
    echo .:$(ls ${PWD}/BOOT-INF/lib/*.jar|tr '\n' ':')${PWD}/BOOT-INF/classes > classpath && \
    apk del unzip

FROM openzipkin/jre-full:11.0.4-11.33
LABEL MAINTAINER Zipkin "https://zipkin.io/"

# Use to set heap, trust store or other system properties.
ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom
# 3rd party modules like zipkin-aws will apply profile settings with this
ENV MODULE_OPTS=

RUN ["/busybox/sh", "-c", "adduser -g '' -h /zipkin -D zipkin"]

# Add environment settings for supported storage types
COPY --from=0 --chown=zipkin /zipkin/ /zipkin/
WORKDIR /zipkin

RUN ["/busybox/sh", "-c", "ln -s /busybox/* /bin"]

USER zipkin

EXPOSE 9410 9411

ENTRYPOINT ["/busybox/sh", "run.sh"]
