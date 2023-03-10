#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM centos:centos6

RUN echo root:changeme | chpasswd

RUN yum clean all -y && yum update -y
RUN yum -y install vim wget rpm-build sudo which telnet tar openssh-server openssh-clients ntp git python-setuptools python-devel httpd lsof && rm -rf /var/cache/yum
RUN rpm -e --nodeps --justdb glibc-common
RUN yum -y install glibc-common && rm -rf /var/cache/yum

ENV HOME /root

#Install JAVA
RUN wget --no-check-certificate --no-cookies --header "Cookie:oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm -O jdk-7u55-linux-x64.rpm
RUN rpm -ivh jdk-7u55-linux-x64.rpm
ENV JAVA_HOME /usr/java/default/

#Install Maven
RUN mkdir -p /opt/maven
WORKDIR /opt/maven
RUN wget https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
RUN tar -xvzf /opt/maven/apache-maven-3.0.5-bin.tar.gz && rm /opt/maven/apache-maven-3.0.5-bin.tar.gz
RUN rm -rf /opt/maven/apache-maven-3.0.5-bin.tar.gz

ENV M2_HOME /opt/maven/apache-maven-3.0.5
ENV MAVEN_OPTS -Xmx2048m -XX:MaxPermSize=256m
ENV PATH $PATH:$JAVA_HOME/bin:$M2_HOME/bin

# SSH key
RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

#To allow bower install behind proxy. See https://github.com/bower/bower/issues/731
RUN git config --global url."https://".insteadOf git://

# Install python, nodejs and npm
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rm -rf /var/cache/yum
RUN yum -y install nodejs npm --enablerepo=epel && rm -rf /var/cache/yum
RUN npm install -g npm@2.1.11 && npm cache clean --force;
RUN npm install -g brunch@1.7.20 && npm cache clean --force;

# Install Solr
ENV SOLR_VERSION 5.5.2
RUN wget --no-check-certificate -O /root/solr-$SOLR_VERSION.tgz https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
RUN cd /root && tar -zxvf /root/solr-$SOLR_VERSION.tgz && rm /root/solr-$SOLR_VERSION.tgz
ADD bin/start.sh /root/start.sh
ADD test-config /root/test-config
ADD test-logs /root/test-logs
RUN chmod -R 777 /root/test-config
RUN chmod +x /root/start.sh

ENV SOLR_CONFIG_LOCATION /root/config/solr
ENV LOGSEARCH_CONFIG_LOCATION /root/config/logsearch
ENV LOGFEEDER_CONFIG_LOCATION /root/config/logfeeder
ENV SOLR_INCLUDE /root/config/solr/solr-env.sh
ENV LOGSEARCH_INCLUDE /root/config/logsearch/logsearch-env.sh
ENV LOGFEEDER_INCLUDE /root/config/logfeeder/logfeeder-env.sh

RUN mkdir -p /var/run/ambari-logsearch-solr /var/log/ambari-logsearch-solr /var/run/ambari-infra-solr-client \
  /var/log/ambari-infra-solr-client /root/logsearch_solr_index/data \
  /var/run/ambari-logsearch-portal /var/log/ambari-logsearch-portal \
  /var/run/ambari-logsearch-logfeeder /var/log/ambari-logsearch-logfeeder

RUN cp /root/test-config/solr/solr.xml /root/logsearch_solr_index/data
RUN cp /root/test-config/solr/zoo.cfg /root/logsearch_solr_index/data

WORKDIR /root
CMD /root/start.sh
