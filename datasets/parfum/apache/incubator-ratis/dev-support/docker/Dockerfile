
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

# Dockerfile for installing the necessary dependencies for building Hadoop.
# See BUILDING.txt.


FROM ubuntu:xenial

WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_TERSE true

######
# Install common dependencies from packages
#
# WARNING: DO NOT PUT JAVA APPS HERE! Otherwise they will install default
# Ubuntu Java.  See Java section below!
######
RUN apt-get -q update && apt-get -q install --no-install-recommends -y \
    curl \
    unzip \
    git \
    wget \
    rsync

# wget configuration

RUN echo "dot_style = mega" > "/root/.wgetrc"
RUN echo "quiet = on" >> "/root/.wgetrc"


#######
# OpenJDK Java
#######

RUN apt-get -q install -y openjdk-8-jdk

######
# Install protobuf compiler
######

RUN mkdir -p $HOME/protobuf && \
    cd $HOME/protobuf && \
    wget https://github.com/google/protobuf/releases/download/v3.5.0/protoc-3.5.0-linux-x86_64.zip && \
    unzip protoc-3.5.0-linux-x86_64.zip && \
    mv $HOME/protobuf/bin/protoc /usr/local/bin && \
    chmod 755 /usr/local/bin/protoc

######
# Install Apache Maven
######
RUN mkdir -p /opt/maven && \
    curl -L -s -S \
         http://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
         -o /opt/maven.tar.gz && \
    tar xzf /opt/maven.tar.gz --strip-components 1 -C /opt/maven
ENV MAVEN_HOME /opt/maven
ENV PATH "$PATH:/opt/maven/bin"

######
# Install findbugs
######
#RUN mkdir -p /opt/findbugs && \
#    curl -L -s -S \
#         https://sourceforge.net/projects/findbugs/files/findbugs/3.0.1/findbugs-noUpdateChecks-3.0.1.tar.gz/download \
#         -o /opt/findbugs.tar.gz && \
#    tar xzf /opt/findbugs.tar.gz --strip-components 1 -C /opt/findbugs
#ENV FINDBUGS_HOME /opt/findbugs

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx512m

