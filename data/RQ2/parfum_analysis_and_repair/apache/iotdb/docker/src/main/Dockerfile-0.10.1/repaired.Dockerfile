#
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
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM openjdk:11-jre-slim
RUN apt update \
  # procps is for `free` command \
  && apt install --no-install-recommends wget unzip lsof procps -y \
  && wget https://archive.apache.org/dist/iotdb/0.10.1-incubating/apache-iotdb-0.10.1-incubating-bin.zip \
  && unzip apache-iotdb-0.10.1-incubating-bin.zip \
  && rm apache-iotdb-0.10.1-incubating-bin.zip \
  && mv apache-iotdb-0.10.1-incubating /iotdb \
  && apt remove wget unzip -y \
  && apt autoremove -y \
  && apt purge --auto-remove -y \
  && apt clean -y && rm -rf /var/lib/apt/lists/*;
EXPOSE 6667
EXPOSE 31999
EXPOSE 5555
EXPOSE 8181
VOLUME /iotdb/data
VOLUME /iotdb/logs
ENV PATH="/iotdb/sbin/:/iotdb/tools/:${PATH}"
ENTRYPOINT ["/iotdb/sbin/start-server.sh"]
