# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information rega4rding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set the base image to CentOS 7
FROM centos:7

#====================================set SSH service====================================================================
RUN yum -y -q install openssh-server epel-release openssh-clients && \
    yum -y -q install pwgen && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && rm -rf /var/cache/yum

ADD ssh_service/set_root_pw.sh /set_root_pw.sh
ADD ssh_service/run.sh /run_ssh.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS "SSH_docker_container_public_key_STRING"
ENV ROOT_PASS SSH_docker_container_password
#====================================set SSH service====================================================================


# Copy the files into Docker
ADD launcher_agent.py /launcher_agent.py
ADD ambari_agent_start.sh /ambari_agent_start.sh
ADD package_list.txt /package_list.txt
ADD ambari_agent_install.sh /ambari_agent_install.sh

RUN chmod 755 /ambari_agent_start.sh && \
    chmod 755 /ambari_agent_install.sh

# Install ambari-agent
RUN /ambari_agent_install.sh

# Set Hadoop Repo
RUN wget -O /etc/yum.repos.d/hdp.repo https://s3.amazonaws.com/dev.hortonworks.com/HDP/centos7/2.x/updates/2.3.0.0/hdp.repo

# Install all package including YARN, HDFS, HBase, Zookeeper, Ambari-Metrics Monitor, etc..
RUN yum install -y -q $(cat package_list.txt) && rm -rf /var/cache/yum

RUN yum update -y -q

# Clean yum download cache
RUN yum clean -y all