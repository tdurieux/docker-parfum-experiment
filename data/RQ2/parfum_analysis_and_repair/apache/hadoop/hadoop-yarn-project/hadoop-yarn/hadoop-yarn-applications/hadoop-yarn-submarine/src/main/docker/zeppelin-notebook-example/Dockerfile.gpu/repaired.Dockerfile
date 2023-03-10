# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM nvidia/cuda:9.0-base-ubuntu16.04

RUN echo "$LOG_TAG update and install basic packages" && \
     apt-get -y update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        vim \
        wget \
        && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen $LANG && \
    apt-get clean && \
    apt -y autoclean && \
    apt -y dist-upgrade && \
    apt-get install --no-install-recommends -y build-essential && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install Zeppelin
ENV Z_VERSION="0.7.3" \
    Z_HOME="/zeppelin"

RUN echo "$LOG_TAG Download Zeppelin binary" && \
    wget -O /tmp/zeppelin-${Z_VERSION}-bin-all.tgz https://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz && \
    tar -zxvf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    rm -rf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    mv /zeppelin-${Z_VERSION}-bin-all ${Z_HOME}
ENV PATH="${Z_HOME}/bin:${PATH}"

RUN echo "$LOG_TAG Set locale" && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY zeppelin-site.xml $Z_HOME/conf/zeppelin-site.xml
COPY shiro.ini ${Z_HOME}/conf/shiro.ini
RUN chmod 777 -R ${Z_HOME}

COPY run_container.sh /usr/local/bin/run_container.sh
RUN chmod 755 /usr/local/bin/run_container.sh

EXPOSE 8080
CMD ["/usr/local/bin/run_container.sh"]
