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

FROM atlas-base:latest


# Install necessary packages to build Atlas
RUN apt-get update && apt-get -y --no-install-recommends install git maven && rm -rf /var/lib/apt/lists/*;

# Set environment variables
ENV MAVEN_HOME /usr/share/maven
ENV PATH       /usr/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/apache-maven/bin

# setup atlas group, and users
RUN mkdir -p /home/atlas/git && \
    mkdir -p /home/atlas/.m2 && \
    chown -R atlas:atlas /home/atlas

COPY ./scripts/atlas-build.sh /home/atlas/scripts/

VOLUME /home/atlas/.m2
VOLUME /home/atlas/scripts
VOLUME /home/atlas/patches
VOLUME /home/atlas/dist
VOLUME /home/atlas/src

USER atlas

ENTRYPOINT [ "/home/atlas/scripts/atlas-build.sh" ]
