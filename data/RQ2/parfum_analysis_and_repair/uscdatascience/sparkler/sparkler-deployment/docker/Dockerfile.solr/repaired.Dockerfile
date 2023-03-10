# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Pull base image.

# NOTE: always run docker build command from root of sparkler project
# Build command:
#    docker build -t sparkler-local -f sparkler-deployment/docker/Dockerfile .

FROM openjdk:13

WORKDIR /data

RUN groupadd --gid 1000 sparkler && \
   useradd -M --uid 1000 --gid 1000 --home /home/sparkler sparkler

RUN mkdir -p /data/sparkler/conf/solr

ADD ./build/conf/solr /data/sparkler/conf/solr

RUN yum -y update && yum -y install wget procps lsof && rm -rf /var/cache/yum

## Setup Solr
RUN wget https://archive.apache.org/dist/lucene/solr/8.5.0/solr-8.5.0.tgz -O /data/solr.tgz && \
    cd /data/ && tar xzf /data/solr.tgz && \
    mv /data/solr-* /data/solr && rm /data/solr.tgz

## Copy the sparkler build
ADD ./build /data/sparkler

# Create the Crawl DB core
RUN /data/solr/bin/solr start -force && \
    /data/solr/bin/solr create_core -force -c crawldb -d /data/sparkler/conf/solr/crawldb/ && \
    /data/solr/bin/solr stop -force

# sparkler  ui with banana dashboard
COPY ./sparkler-ui/sparkler-dashboard/sparkler-ui-*.war /data/solr/server/solr-webapp/sparkler
RUN cp /data/sparkler/conf/solr/sparkler-jetty-context.xml /data/solr/server/contexts/ && chown -R sparkler:sparkler /data

## Patch Solr's Jetty for Banana with the CSP directive header
COPY ./sparkler-deployment/docker/jetty-csp-patch/jetty.xml /data/solr/server/etc/jetty.xml

USER sparkler
# Define default command.
CMD ["bash"]
