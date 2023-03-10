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

FROM ubuntu:20.04


# Install tzdata, Python, Java
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata \
    python python3 python3-pip openjdk-8-jdk bc iputils-ping ssh pdsh && rm -rf /var/lib/apt/lists/*;

# Set environment variables
ENV JAVA_HOME      /usr/lib/jvm/java-8-openjdk-amd64
ENV ATLAS_DIST    /home/atlas/dist
ENV ATLAS_HOME    /opt/atlas
ENV ATLAS_SCRIPTS /home/atlas/scripts
ENV PATH          /usr/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# setup groups, users, directories
RUN groupadd atlas && \
    useradd -g atlas -ms /bin/bash atlas && \
    groupadd hadoop && \
    useradd -g hadoop -ms /bin/bash hdfs && \
    useradd -g hadoop -ms /bin/bash yarn && \
    useradd -g hadoop -ms /bin/bash hive && \
    useradd -g hadoop -ms /bin/bash hbase && \
    useradd -g hadoop -ms /bin/bash kafka && \
    mkdir -p /home/atlas/dist && \
    mkdir -p /home/atlas/scripts && \
    chown -R atlas:atlas /home/atlas

ENTRYPOINT [ "/bin/bash" ]
