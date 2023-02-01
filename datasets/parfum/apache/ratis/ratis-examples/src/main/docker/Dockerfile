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

FROM openjdk:8-jdk
RUN apt-get update && apt-get install -y jq curl python python-pip sudo netcat && apt-get clean
RUN pip install robotframework
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
RUN mkdir -p /etc/security/keytabs && chmod -R a+wr /etc/security/keytabs
ADD https://repo.maven.apache.org/maven2/org/jboss/byteman/byteman/4.0.4/byteman-4.0.4.jar /opt/byteman.jar
RUN chmod o+r /opt/byteman.jar
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH $PATH:/opt/ratis/bin

RUN apt-get install -y jsvc
ENV JSVC_HOME=/usr/bin

RUN addgroup --gid 1000 ratis
RUN adduser --disabled-password --gecos "" --uid 1000 ratis --gid 100 --home /opt/ratis
RUN echo "ratis ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown ratis /opt

WORKDIR /opt/ratis

VOLUME /data
USER ratis
