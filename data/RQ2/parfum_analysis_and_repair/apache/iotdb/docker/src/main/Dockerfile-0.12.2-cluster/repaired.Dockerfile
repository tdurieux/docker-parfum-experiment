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
  && wget https://downloads.apache.org/iotdb/0.12.2/apache-iotdb-0.12.2-cluster-bin.zip \
  # if you are in China, use the following URL
  #&& wget https://mirrors.tuna.tsinghua.edu.cn/apache/iotdb/0.12.2/apache-iotdb-0.12.2-cluster-bin.zip \
  && unzip apache-iotdb-0.12.2-cluster-bin.zip \
  && rm apache-iotdb-0.12.2-cluster-bin.zip \
  && mv apache-iotdb-0.12.2-cluster-bin /iotdb \
  && apt remove wget unzip -y \
  && apt autoremove -y \
  && apt purge --auto-remove -y \
  && apt clean -y \
  # modify the seeds in configuration file
  && sed -i '/^seed_nodes/cseed_nodes=127.0.0.1:9003' /iotdb/conf/iotdb-cluster.properties \
  && sed -i '/^default_replica_num/cdefault_replica_num=1' /iotdb/conf/iotdb-cluster.properties && rm -rf /var/lib/apt/lists/*;

# rpc port
EXPOSE 6667
# JMX port
EXPOSE 31999
# sync port
EXPOSE 5555
# monitor port
EXPOSE 8181
# internal meta port
EXPOSE 9003
# internal data port
EXPOSE 40010
VOLUME /iotdb/data
VOLUME /iotdb/logs
ENV PATH="/iotdb/sbin/:/iotdb/tools/:${PATH}"
ENTRYPOINT ["/iotdb/sbin/start-node.sh"]
