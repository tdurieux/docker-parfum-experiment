# Copyright 2016 Teradata
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM teradatalabs/iop-base:unlabelled
MAINTAINER Teradata Docker Team <docker@teradata.com>

# INSTALL HADOOP AND HIVE
RUN \
  yum install -y \
    zookeeper_4_2_0_0-server \
  && ln -s /usr/iop/4.2.0.0/zookeeper/bin/zookeeper-server /usr/bin/zookeeper-server \
  && yum -y clean all && rm -rf /tmp/* /var/tmp/* && rm -rf /var/cache/yum

# INSTALL MYSQL (Hive Metastore)
RUN yum install -y mysql-server mysql-connector-java \
    && yum -y clean all && rm -rf /tmp/* /var/tmp/* \
    && ln -s /usr/share/java/mysql-connector-java.jar /usr/iop/4.2.0.0/hive/lib/mysql-connector-java.jar && rm -rf /var/cache/yum

# ADD SETUP AND BOOTSTRAP SCRIPTS
COPY files/bootstrap.sh files/setup.sh /root/

# CREATE CONF DIRECTORIES
RUN mkdir /tmp/hadoop_conf
COPY files/conf/ /tmp/hadoop_conf

# COPY SETUP CONFIGURATION
COPY files/conf-setup/ /etc/hadoop/conf

COPY files/conf-zookeeper/* /etc/zookeeper/conf/

# Create needed dirs
RUN mkdir /var/lib/zookeeper
RUN chown zookeeper:hadoop /var/lib/zookeeper

# RUN SETUP script
RUN /root/setup.sh && rm -rf /tmp/* /var/tmp/*

# SETUP SOCKS PROXY
RUN yum install -y openssh openssh-clients openssh-server && rm -rf /var/cache/yum
RUN ssh-keygen -t rsa -b 4096 -C "automation@teradata.com" -N "" -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
ADD files/socks-proxy.sh /root/socks-proxy.sh

# HDFS PORTS
EXPOSE 1004 1006 8020 50010 50020 50070 50075 50470

# YARN PORTS
EXPOSE 8030 8031 8032 8033 8040 8041 8042 8088 10020 19888

# HIVE PORT
EXPOSE 9083 10000

# SOCKS PORT
EXPOSE 1180

CMD /root/startup.sh
