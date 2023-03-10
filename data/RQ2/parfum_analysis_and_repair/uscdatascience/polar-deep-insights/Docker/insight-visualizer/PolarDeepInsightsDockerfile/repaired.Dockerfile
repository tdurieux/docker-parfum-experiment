# encoding: utf-8
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04
MAINTAINER USC Information Retrieval and Data Science (IRDS) irds-L@mymaillists.usc.edu

# Internal unpriviled user will have this ID:
ENV CONTAINER_USER_ID="pdi" \
    CONTAINER_GROUP_ID="pdi"

ENV PDI_HOME="/home/pdi/src/polar-deep-insights"

# Updates OS and adds system required packages
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      apache2 \
      openjdk-8-jre \
      nodejs \
      nodejs-legacy \
      npm \
      vim \
      emacs \
      git \
      sudo \
      ruby \
      ruby-dev \
      curl \
      libffi-dev \
      build-essential \
      software-properties-common \
      wget \
      unzip \
        && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*

# OpenJDK version 8 for ES
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install --no-install-recommends -y \
      openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

RUN gem install compass

# creates a user "pdi"
RUN useradd -U -d /home/pdi -s /bin/sh ${CONTAINER_USER_ID}
RUN mkdir /home/pdi
RUN chown -R pdi:pdi /home/pdi

# sudo access
RUN adduser pdi sudo
RUN echo "pdi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Global npm folder writeable by "pdi"
RUN mkdir -p /opt/npm-global && \
    chown pdi:pdi /opt/npm-global

# After this point everthing is done as unpriveleged user
USER pdi

# configuring environment variables
ENV NPM_CONFIG_PREFIX=/opt/npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

# Installing usefull npm packages
RUN npm install -g \
    npm@3.10.6 \
    grunt@1.0.1 \
    grunt-cli@1.2.0 \
    bower@1.8.4 \
    yo@1.8.4 && npm cache clean --force;

# Creating a directory inside the container
RUN mkdir /home/pdi/src
WORKDIR /home/pdi/src

# Copy entrypoint script into the container
COPY ./entrypoint.sh /deploy/entrypoint.sh

# Checkout PDI and then enter insights-visualizer dir
RUN git clone https://github.com/USCDataScience/polar-deep-insights.git
WORKDIR /home/pdi/src/polar-deep-insights/insight-visualizer/

# Override template htmls for context /pdi for Apache2

COPY app-conf/ng-app/scripts/components/configuration/template.html /home/pdi/src/polar-deep-insights/insight-visualizer/app/scripts/components/configuration/template.html
COPY app-conf/ng-app/scripts/components/navigation/template.html /home/pdi/src/polar-deep-insights/insight-visualizer/app/scripts/components/navigation/template.html

# Build
RUN npm install && bower install && npm cache clean --force;

# Always root is set as the owner, so let's change it to pdi
USER root
RUN chown -R pdi:pdi /deploy
RUN chown -R pdi:pdi /home/pdi/src
USER pdi

# Install ElasticSearch 2.4.6
WORKDIR /deploy
RUN curl -f -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.4.6/elasticsearch-2.4.6.zip
RUN unzip elasticsearch-2.4.6.zip

# Install Elasticsearch-Tools
RUN npm install -g elasticsearch-tools && npm cache clean --force;

# configuring environment variables
ENV ELASTIC_PATH=/deploy/elasticsearch-2.4.6
ENV PATH=$ELASTIC_PATH/bin:$PATH

# start Apache HTTPD
USER root
ENV APACHE_RUN_USER pdi
ENV APACHE_RUN_GROUP pdi
ENV APACHE_LOG_DIR /var/log/apache2
COPY ./app-conf/httpd/pdi.conf /etc/apache2/conf-enabled
RUN a2enmod proxy_http proxy_ajp rewrite headers
RUN echo "ServerName pdi" >> /etc/apache2/apache2.conf
RUN chown -R pdi:pdi /etc/apache2 /var/log/apache2
USER pdi

EXPOSE 80
EXPOSE 9000
EXPOSE 9200
EXPOSE 35729

ENTRYPOINT ["/deploy/entrypoint.sh"]
