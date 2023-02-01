#
# Copyright 2014-2018 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hawkular-Metrics DockerFile
#
# This dockerfile can be used to create a Hawkular-Metrics Schema docker
# image to be run on Openshift.

#FROM fabric8/java-jboss-openjdk8-jdk:1.4.0
FROM jboss/base-jdk:8

# The image is maintained by the Hawkular Metrics team
MAINTAINER Hawkular Metrics <hawkular-dev@lists.jboss.org>

ENV HAWKULAR_METRICS_VERSION="0.31.0.Final" \
    HAWKULAR_METRICS_DIR="/opt/hawkular/" \
    RESET_DB="false" \
    CASSANDRA_NODES="hawkular-cassandra" \
    CASSANDRA_CONNECTION_MAX_DELAY="30" \
    CASSANDRA_CONNECTION_MAX_RETRIES="5" \
    VERSION_UPDATE_DELAY="5" \
    VERSION_UPDATE_MAX_RETRIES="10"

ARG DEV_BUILD="false"

USER root

RUN mkdir $HAWKULAR_METRICS_DIR
COPY dev/* $HAWKULAR_METRICS_DIR
COPY hawkular-metrics-schema.sh $HAWKULAR_METRICS_DIR

RUN cd $HAWKULAR_METRICS_DIR && \
    if [ ${DEV_BUILD} != "true" ] || [ ! -s ${HAWKULAR_METRICS_DIR}/hawkular-metrics-schema-installer.jar ]; then echo "!!!NOT A DEV BUILD!!!"; curl -Lo hawkular-metrics-schema-installer.jar https://origin-repository.jboss.org/nexus/service/local/artifact/maven/content?r=public\&g=org.hawkular.metrics\&a=hawkular-metrics-schema-installer\&e=jar\&v=${HAWKULAR_METRICS_VERSION}; fi

RUN yum -y install openssl \
    && chmod -R 777 /opt

ENTRYPOINT $HAWKULAR_METRICS_DIR/hawkular-metrics-schema.sh
