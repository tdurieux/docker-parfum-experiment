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

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# Install some development tools and packages
# MXNet 1.6 is going to be the last MXNet release to support Python2
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tzdata git \
    wget zip python3 python3-pip python3-distutils libgomp1 libopenblas-dev libopencv-dev && rm -rf /var/lib/apt/lists/*;

# Install latest MXNet with CUDA-10.0 using pip
RUN pip3 install --no-cache-dir mxnet-cu100

# Install JDK
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Hadoop
WORKDIR /
RUN echo "Install Hadoop 3.1.2"
ENV HADOOP_VERSION="3.1.2"
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN tar zxf hadoop-${HADOOP_VERSION}.tar.gz && rm hadoop-${HADOOP_VERSION}.tar.gz
RUN ln -s hadoop-${HADOOP_VERSION} hadoop-current
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

RUN echo "Install python related packages" && \
    pip3 install --no-cache-dir --user graphviz==0.8.4 ipykernel jupyter matplotlib numpy pandas scipy sklearn && \
    python3 -m ipykernel.kernelspec

# Set the locale to fix bash warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
