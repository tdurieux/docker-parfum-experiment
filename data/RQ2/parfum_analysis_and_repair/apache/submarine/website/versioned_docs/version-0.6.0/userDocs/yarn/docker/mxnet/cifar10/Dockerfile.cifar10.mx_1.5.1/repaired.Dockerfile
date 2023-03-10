# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y git wget zip python3 python3-pip \
    python3-distutils openjdk-8-jdk libgomp1 apt-transport-https ca-certificates curl \
    gnupg-agent software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install MXNet
RUN pip3 install --no-cache-dir "mxnet==1.5.1"

# Install hadoop 3.1.0+ supported YARN service
ENV HADOOP_VERSION="3.1.2"
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
# If you are in mainland China, you can use the following command.
# RUN wget http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

RUN tar -xvf hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ && rm hadoop-${HADOOP_VERSION}.tar.gz
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

# Copy the $HADOOP_CONF_DIR folder as "hadoop" folder in the same dir as dockerfile .
# ├── Dockerfile.cifar10_mx_1.5.1
# └── hadoop
#     ├── capacity-scheduler.xml
#     ├── configuration.xsl
#     ...
COPY hadoop /opt/hadoop-$HADOOP_VERSION/etc/hadoop

# Config Hadoop env
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_YARN_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_HDFS_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_CONF_DIR=/opt/hadoop-$HADOOP_VERSION/etc/hadoop
ENV HADOOP_COMMON_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_MAPRED_HOME=/opt/hadoop-$HADOOP_VERSION

# Create a user, make sure the user groups are the same as your host
# and the container user's UID is same as your host's.
RUN groupadd -g 5000 hadoop
RUN useradd -u 1000 -g hadoop pi
