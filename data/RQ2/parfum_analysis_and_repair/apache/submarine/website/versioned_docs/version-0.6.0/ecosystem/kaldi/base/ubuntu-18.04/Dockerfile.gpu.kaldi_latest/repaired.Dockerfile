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

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        openjdk-8-jdk \
        iputils-ping \
        g++ \
        make \
        automake \
        autoconf \
        bzip2 \
        unzip \
        wget \
        sox \
        libtool \
        git \
        subversion \
        python2.7 \
        python3 \
        zlib1g-dev \
        ca-certificates \
        patch \
        ffmpeg \
        vim && \
        rm -rf /var/lib/apt/lists/* && \
        ln -s /usr/bin/python2.7 /usr/bin/python

RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi && \
    cd /opt/kaldi && \
    cd /opt/kaldi/tools && \
    ./extras/install_mkl.sh && \
    make -j $(nproc) && \
    cd /opt/kaldi/src && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --shared --use-cuda && \
    make depend -j $(nproc) && \
    make -j $(nproc)

WORKDIR /
# Install Hadoop
ENV HADOOP_VERSION="3.2.1"
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ARG CLUSTER_NAME=submarine
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar zxf hadoop-${HADOOP_VERSION}.tar.gz && \
    ln -s hadoop-${HADOOP_VERSION} hadoop-current && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

RUN echo "Install python related packages" && \
    pip --no-cache-dir install Pillow h5py ipykernel jupyter matplotlib numpy pandas scipy sklearn && \
    python -m ipykernel.kernelspec

ENV CLUSTER_NAME="admin" # Your cluster user sets root privileges
RUN echo "## Allow root to run any commands anywhere" >> /etc/sudoers && \
    echo "User_Alias   USER_ROOT   = tf-docker, $CLUSTER_NAME" >> /etc/sudoers && \
    echo "root        ALL=(ALL)    ALL" >> /etc/sudoers && \
    echo "USER_ROOT   ALL=(ALL)    ALL" >> /etc/sudoers && \
    echo "USER_ROOT   ALL=(ALL)    NOPASSWD: ALL" >> /etc/sudoers