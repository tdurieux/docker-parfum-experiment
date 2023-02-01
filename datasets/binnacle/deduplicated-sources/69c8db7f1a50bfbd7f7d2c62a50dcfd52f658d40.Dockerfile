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

FROM ubuntu:trusty

LABEL maintainer="Daniel Kuppitz <me@gremlin.guru>"

RUN apt-get update
RUN apt-get -y install software-properties-common python-software-properties apt-transport-https curl dpkg
RUN add-apt-repository ppa:openjdk-r/ppa
RUN sh -c 'curl -s https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb'
RUN sh -c 'dpkg -i packages-microsoft-prod.deb'
RUN sh -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable-trusty main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk gawk git maven openssh-server subversion zip
RUN apt-get install -y --force-yes dotnet-sdk-2.2 python python-dev python3-dev python-pip build-essential mono-devel
RUN pip install virtualenv virtualenvwrapper
RUN pip install --upgrade pip
RUN rm -rf /var/lib/apt/lists/* /var/cache/openjdk-8-jdk

RUN sed -i 's@PermitRootLogin without-password@PermitRootLogin yes@' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuuid.so@g' /etc/pam.d/sshd
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN sed -i 's/.*"$PS1".*/# \0/' ~/.bashrc
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bashrc

RUN echo "Host *" >> ~/.ssh/config
RUN echo "  UserKnownHostsFile /dev/null" >> ~/.ssh/config
RUN echo "  StrictHostKeyChecking no" >> ~/.ssh/config
