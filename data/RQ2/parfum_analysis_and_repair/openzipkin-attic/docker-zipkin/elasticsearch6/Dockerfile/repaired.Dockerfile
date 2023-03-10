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

ENV ELASTICSEARCH_VERSION 6.8.3

RUN apk add --no-cache --update curl

WORKDIR /elasticsearch

RUN curl -f -sSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz | tar xz && \
    mv elasticsearch-$ELASTICSEARCH_VERSION/* /elasticsearch/

FROM openzipkin/jre-full:11.0.4-11.33
LABEL MAINTAINER Zipkin "https://zipkin.io/"

# https://github.com/elastic/elasticsearch/pull/31003 was closed won't fix
ENV ES_TMPDIR /tmp

RUN ["/busybox/sh", "-c", "adduser -g '' -h /elasticsearch -D elasticsearch"]

COPY --from=0 --chown=elasticsearch /elasticsearch /elasticsearch

WORKDIR /elasticsearch

# elasticsearch complains if run as root
USER elasticsearch

COPY config ./config

EXPOSE 9200 9300

ENV JAVA_OPTS " "

ENTRYPOINT ["/busybox/sh", "/elasticsearch/bin/elasticsearch"]
