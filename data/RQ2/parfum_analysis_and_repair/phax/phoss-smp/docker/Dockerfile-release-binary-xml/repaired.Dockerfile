#
# Copyright (C) 2015-2019 Philip Helger (www.helger.com)
# philip[at]helger[dot]com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM --platform=$BUILDPLATFORM ubuntu:latest as build

# Install wget and unzip
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y wget unzip \
  && rm -rf /var/lib/apt/lists/*

ARG SMP_VERSION
# Set to environment to be persistent
ENV SMP_VERSION=${SMP_VERSION:-5.7.0}

# Download the SMP from GitHub releases
# Unzip the WAR file to /smp
# Remove the default "application.properties" file to avoid invalid default configuration
RUN echo Downloading phoss SMP $SMP_VERSION \
  && wget -nv https://github.com/phax/phoss-smp/releases/download/phoss-smp-parent-pom-$SMP_VERSION/phoss-smp-webapp-xml-$SMP_VERSION.war -O smp.zip \ 
  && unzip smp.zip -d /smp \
  && rm /smp/WEB-INF/classes/application.properties


# Use an official Tomcat runtime as a base image
FROM tomcat:9-jdk11

# Special encoded slash handling for SMP
# Use non-blocking random
ENV CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Djava.security.egd=file:/dev/urandom"

# Set arguments and labels after initial cleanup was performed
ARG SMP_VERSION
# Set to environment to be persistent
ENV SMP_VERSION=${SMP_VERSION:-5.7.0}
LABEL vendor="Philip Helger"
LABEL version=$SMP_VERSION

COPY --from=build /smp $CATALINA_HOME/webapps/ROOT
WORKDIR /home/git
