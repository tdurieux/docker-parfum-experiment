#
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
ARG JAVA_VERSION=11
ARG OPENJDK_IMAGE=openjdk
FROM ${OPENJDK_IMAGE}:${JAVA_VERSION} AS pinot_build_env

LABEL MAINTAINER=dev@pinot.apache.org

ARG PINOT_BRANCH=master
ARG KAFKA_VERSION=2.0
ARG JDK_VERSION=11
ARG PINOT_GIT_URL="https://github.com/apache/pinot.git"
RUN echo "Trying to build Pinot from [ ${PINOT_GIT_URL} ] on branch [ ${PINOT_BRANCH} ] with Kafka version [ ${KAFKA_VERSION} ]"
ENV PINOT_HOME=/opt/pinot
ENV PINOT_BUILD_DIR=/opt/pinot-build

# extra dependency for running launcher
RUN apt-get update && \
    apt-get install -y --no-install-recommends vim wget curl git automake bison flex g++ libboost-all-dev libevent-dev \
    libssl-dev libtool make pkg-config && \
    rm -rf /var/lib/apt/lists/*

# install maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp \
  && tar -xzf /tmp/apache-maven-*.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven-*.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG /opt/.m2

# install thrift
RUN wget https://archive.apache.org/dist/thrift/0.12.0/thrift-0.12.0.tar.gz -O /tmp/thrift-0.12.0.tar.gz && \
     tar xfz /tmp/thrift-0.12.0.tar.gz --directory /tmp && \
     base_dir=`pwd` && \
     cd /tmp/thrift-0.12.0 && \
     ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-cpp=no --with-c_glib=no --with-java=yes --with-python=no --with-ruby=no --with-erlang=no --with-go=no --with-nodejs=no --with-php=no && \
     make install && rm /tmp/thrift-0.12.0.tar.gz

RUN git clone ${PINOT_GIT_URL} ${PINOT_BUILD_DIR} && \
    cd ${PINOT_BUILD_DIR} && \
    git checkout ${PINOT_BRANCH} && \
    mvn install package -DskipTests -Pbin-dist -Pbuild-shaded-jar -Djdk.version=${JDK_VERSION} -T1C && \
    mkdir -p ${PINOT_HOME}/configs && \
    mkdir -p ${PINOT_HOME}/data && \
    cp -r build/* ${PINOT_HOME}/. && \
    chmod +x ${PINOT_HOME}/bin/*.sh

FROM ${OPENJDK_IMAGE}:${JAVA_VERSION}-jdk-slim

LABEL MAINTAINER=dev@pinot.apache.org

ENV PINOT_HOME=/opt/pinot
ENV JAVA_OPTS="-Xms4G -Xmx4G -Dpinot.admin.system.exit=false"

VOLUME ["${PINOT_HOME}/configs", "${PINOT_HOME}/data"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim less wget curl git python sysstat procps linux-perf openjdk-11-dbg && \
    rm -rf /var/lib/apt/lists/*

RUN case `uname -m` in \
    x86_64) arch=x64; ;; \
    aarch64) arch=arm64; ;; \
    *) echo "platform=$(uname -m) un-supported, exit ..."; exit 1; ;; \
  esac \
  && mkdir -p /usr/local/lib/async-profiler \
  && curl -f -L https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.5.1/async-profiler-2.5.1-linux-${arch}.tar.gz | tar -xz --strip-components 1 -C /usr/local/lib/async-profiler \
  && ln -s /usr/local/lib/async-profiler/profiler.sh /usr/local/bin/async-profiler

COPY --from=pinot_build_env ${PINOT_HOME} ${PINOT_HOME}
COPY bin ${PINOT_HOME}/bin
COPY etc ${PINOT_HOME}/etc
COPY examples ${PINOT_HOME}/examples

RUN wget -O ${PINOT_HOME}/etc/jmx_prometheus_javaagent/jmx_prometheus_javaagent-0.12.0.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.12.0/jmx_prometheus_javaagent-0.12.0.jar
RUN wget -O ${PINOT_HOME}/etc/jmx_prometheus_javaagent/jmx_prometheus_javaagent-0.16.1.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.1/jmx_prometheus_javaagent-0.16.1.jar && \
    ln -s ${PINOT_HOME}/etc/jmx_prometheus_javaagent/jmx_prometheus_javaagent-0.16.1.jar ${PINOT_HOME}/etc/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar

# expose ports for controller/broker/server/admin
EXPOSE 9000 8099 8098 8097 8096

WORKDIR ${PINOT_HOME}

ENTRYPOINT ["./bin/pinot-admin.sh"]

CMD ["-help"]
