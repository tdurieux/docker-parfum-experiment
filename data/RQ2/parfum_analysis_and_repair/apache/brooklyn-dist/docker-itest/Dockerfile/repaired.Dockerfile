# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM maven:3.5.2-jdk-8

# For Alpine:
# FROM maven:3.3.9-jdk-8-alpine
# RUN apk add --update --no-cache bash netcat-openbsd sudo wget openssh
# RUN ssh-keygen -A
# This is missing knife - adding it would grow the image size considerably
# making it on par with the full debian image. Also some tests fail
# because of differences in the accepted arguments of the busybox provided tools.

# Install the non-headless JRE as some tests requires them
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

# Install necessary binaries to build brooklyn
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    git-core \
    procps \
    golang-go \
    rpm \
    dpkg \
    libpng-dev \
    make \
    automake \
    autoconf \
    libtool \
    dpkg \
    pkg-config \
    nasm \
    gcc \
    net-tools \
    ssh \
    sudo \
    wget \
    chef && \
    rm -rf /var/lib/apt/lists/*

# Prepare container for IT tests
RUN mkdir /etc/skel/.m2 && \
    echo "<settings xmlns='http://maven.apache.org/SETTINGS/1.0.0'>" > /etc/skel/.m2/settings.xml && \
    echo "  <localRepository>/var/maven</localRepository>" >> /etc/skel/.m2/settings.xml && \
    echo "</settings>" >> /etc/skel/.m2/settings.xml && \
    : The following are integration tests requirements && \
    echo "127.0.0.1 localhost1 localhost2 localhost3 localhost4" >> /etc/hosts && \
    mkdir /etc/skel/.brooklyn && \
    cd /etc/skel/.brooklyn && \
    wget -q https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz && \
    gunzip GeoLite2-City.mmdb.gz && \
    echo "brooklyn.location.named.localhost-passphrase=localhost" >> brooklyn.properties && \
    echo "brooklyn.location.named.localhost-passphrase.privateKeyFile=~/.ssh/id_rsa_with_passphrase" >> brooklyn.properties && \
    echo "brooklyn.location.named.localhost-passphrase.privateKeyPassphrase=mypassphrase" >> brooklyn.properties && \
    chmod 600 brooklyn.properties

# Add the brooklyn user at runtime so that we can set its USER_ID same as the user that's calling "docker run"
# We need them the same so that the mounted /build volume is accessible from inside the container.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make sure the /.config && /.npm (for UI module builds) is writable for all users
RUN mkdir -p /.config && chmod -R 777 /.config
RUN mkdir -p /.npm && chmod -R 777 /.npm

# Make sure the /var/tmp (for RPM build) is writable for all users
RUN mkdir -p /var/tmp/ && chmod -R 777 /var/tmp/

# Make sure the /var/maven is writable for all users
RUN mkdir -p /var/maven/.m2/ && chmod -R 777 /var/maven/
ENV MAVEN_CONFIG=/var/maven/.m2

VOLUME /usr/build
VOLUME /var/maven

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mvn -B clean test -PIntegration"]
