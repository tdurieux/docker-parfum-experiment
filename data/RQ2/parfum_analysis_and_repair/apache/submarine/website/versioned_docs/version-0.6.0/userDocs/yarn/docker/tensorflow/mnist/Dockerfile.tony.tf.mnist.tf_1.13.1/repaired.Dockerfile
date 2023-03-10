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

FROM ubuntu:18.04
ENV HADOOP_VERSION 2.9.2
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN apt-get update && apt-get -y --no-install-recommends install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     git \
     software-properties-common \
     openjdk-8-jdk vim \
     wget python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Download Hadoop binaries.
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

# Copy the $HADOOP_CONF_DIR folder as "hadoop" folder in the same dir as dockerfile
# pi@pi-aw:~/apache/submarine/docker$ tree
# .
# ├── Dockerfile
# └── hadoopconf
#     ├── capacity-scheduler.xml
#     ├── configuration.xsl
#     ...
COPY hadoopconf /opt/hadoop-$HADOOP_VERSION/etc/hadoop

# Download and config submarine
RUN cd ~
RUN git clone https://github.com/apache/submarine.git
RUN cd submarine

RUN submarine/dev-support/mini-submarine/submarine/build_python_virtual_env.sh
RUN mv venv/ /opt/
RUN chmod +r -R /opt/venv

# Config Hadoop env
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_YARN_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_HDFS_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_CONF_DIR=/opt/hadoop-$HADOOP_VERSION/etc/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Crate user, make sure the user groups are the same as your host
RUN groupadd -g 5000 hadoop
RUN useradd -u 1000 -g hadoop pi
RUN mkdir /home/pi
RUN chown pi:hadoop /home/pi
RUN mkdir /tmp/mode
RUN chmod 777 /tmp/mode
