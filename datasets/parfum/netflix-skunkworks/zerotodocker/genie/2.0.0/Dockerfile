# Copyright 2015 Netflix, Inc.
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

FROM netflixoss/tomcat:7
MAINTAINER Netflix Open Source Development <talent@netflix.com>

# Properties to set
ENV CATALINA_OPTS="-Dspring.profiles.active=prod -Darchaius.deployment.applicationId=genie -Darchaius.deployment.environment=dev"

# Download and configure the Genie WAR file and Genie Jobs directory where job results will be stored
RUN wget -q -P /tomcat/webapps 'http://jcenter.bintray.com/com/netflix/genie/genie-web/2.0.0/genie-web-2.0.0.war' &&\
  mkdir /tomcat/webapps/ROOT &&\
  cd /tomcat/webapps/ROOT &&\
  jar xf ../genie-web-2.0.0.war &&\
  cd .. &&\
  rm genie-web-2.0.0.war &&\
  mkdir /tomcat/webapps/genie-jobs &&\
  wget -q -P /tomcat/conf 'https://raw.githubusercontent.com/Netflix/genie/2.0.0/genie-web/conf/system/apps/tomcat/conf/listings.xsl' &&\
  sed -i '111s/false/true/' /tomcat/conf/web.xml &&\
  sed -i '113i\ \ \ \ \ \ \ \ <init-param>\n\ \ \ \ \ \ \ \ \ \ \ \ <param-name>globalXsltFile<\/param-name>\n\ \ \ \ \ \ \ \ \ \ \ \ <param-value>\/tomcat\/conf\/listings.xsl<\/param-value>\n\ \ \ \ \ \ \ \ <\/init-param>' /tomcat/conf/web.xml

# Modify the default database properties for the mysql-genie docker link
RUN mkdir /tmp/genie-server &&\
  cp /tomcat/webapps/ROOT/WEB-INF/lib/genie-server-2.0.0.jar /tmp/genie-server/ &&\
  cd /tmp/genie-server/ &&\
  jar xf genie-server-2.0.0.jar &&\
  rm genie-server-2.0.0.jar &&\
  sed -i '54s/127.0.0.1/mysql-genie/' genie-jpa.xml &&\
  sed -i '56s/value=""/value="genie"/' genie-jpa.xml &&\
  jar cf genie-server-2.0.0.jar * &&\
  mv genie-server-2.0.0.jar /tomcat/webapps/ROOT/WEB-INF/lib/ &&\
  cd /tomcat &&\
  rm -rf /tmp/genie-server

# Modify default properties to map to the Docker image locations and settings
RUN sed -i '22s/7001/8080/' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '77s/\/mnt\/tomcat\/genie-jobs/\/tomcat\/webapps\/genie-jobs/' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '51s/\/usr\/lib\/jvm\/java-6-sun/\/usr\/lib\/jvm\/java-7-oracle/' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '54s/\/apps\/hadoop\/current/\/apps\/hadoop\/2.6.0/' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '56s/netflix.genie.server.hadoop.2.4.0.home=\/apps\/hadoop\/2.4.0/netflix.genie.server.hadoop.2.6.0.home=\/apps\/hadoop\/2.6.0/' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '55d' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '81,86d' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties &&\
  sed -i '81inetflix.genie.server.hadoop.s3cp.opts=' /tomcat/webapps/ROOT/WEB-INF/classes/genie.properties

# Download all the Genie scripts that are used to run jobs
RUN mkdir -p /apps/genie/bin &&\
  wget -q -P /apps/genie/bin 'https://raw.githubusercontent.com/Netflix/genie/2.0.0/genie-web/conf/system/apps/genie/bin/jobkill.sh' &&\
  chmod 755 /apps/genie/bin/jobkill.sh &&\
  wget -q -P /apps/genie/bin 'https://raw.githubusercontent.com/Netflix/genie/2.0.0/genie-web/conf/system/apps/genie/bin/joblauncher.sh' &&\
  chmod 755 /apps/genie/bin/joblauncher.sh &&\
  sed -i '77s/conf/etc\/hadoop/' /apps/genie/bin/joblauncher.sh &&\
  wget -q -P /apps/genie/bin 'https://raw.githubusercontent.com/Netflix/genie/2.0.0/genie-web/conf/system/apps/genie/bin/localCleanup.py' &&\
  chmod 755 /apps/genie/bin/localCleanup.py &&\
  wget -q -P /apps/genie/bin 'https://raw.githubusercontent.com/Netflix/genie/2.0.0/genie-web/conf/system/apps/genie/bin/timeout3' &&\
  chmod 755 /apps/genie/bin/timeout3

# Below here optional to run Genie and can be different for different deployments

# Download and configure hadoop client
RUN mkdir -p /apps/hadoop/2.6.0 &&\
  cd /apps/hadoop/2.6.0 &&\
  wget -q -P /apps/hadoop/2.6.0 'http://apache.cs.utah.edu/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz' &&\
  tar xf hadoop-2.6.0.tar.gz &&\
  rm hadoop-2.6.0.tar.gz &&\
  chown root:root -R hadoop-2.6.0 &&\
  mv hadoop-2.6.0/* . &&\
  rm -rf hadoop-2.6.0

ENV HADOOP_HOME=/apps/hadoop/2.6.0
ENV HADOOP_PREFIX=$HADOOP_HOME
ENV PATH=$HADOOP_HOME/bin:$PATH

# This is not needed to get Genie working as the scripts loaded into conf below can be copied at runtime
# I'm just adding them here so that all hadoop/pig/hive commands can connect to the cluster from Genie node by default
# in case someone wants to mess around with them as a client
ADD hadoop/2.6.0/conf/*.xml $HADOOP_HOME/etc/hadoop/

# Download and configure pig client
RUN mkdir -p /apps/pig/0.14.0 &&\
  cd /apps/pig/0.14.0 &&\
  wget -q -P /apps/pig/0.14.0 'http://apache.cs.utah.edu/pig/pig-0.14.0/pig-0.14.0.tar.gz' &&\
  tar xf pig-0.14.0.tar.gz &&\
  rm pig-0.14.0.tar.gz &&\
  chown root:root -R pig-0.14.0 &&\
  mv pig-0.14.0/* . &&\
  rm -rf pig-0.14.0

ENV PIG_HOME=/apps/pig/0.14.0
ENV PATH=$PIG_HOME/bin:$PATH

# Download and configure hive client
RUN mkdir -p /apps/hive/1.0.0 &&\
  cd /apps/hive/1.0.0 &&\
  wget -q -P /apps/hive/1.0.0 'http://apache.cs.utah.edu/hive/hive-1.0.0/apache-hive-1.0.0-bin.tar.gz' &&\
  tar xf apache-hive-1.0.0-bin.tar.gz &&\
  rm apache-hive-1.0.0-bin.tar.gz &&\
  chown root:root -R apache-hive-1.0.0-bin &&\
  mv apache-hive-1.0.0-bin/* . &&\
  rm -rf apache-hive-1.0.0-bin

ENV HIVE_HOME=/apps/hive/1.0.0
ENV PATH=$HIVE_HOME/bin:$PATH

# Install some packages that will be used for the example
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y install python python-pip vim &&\
  python -m pip install --no-input --upgrade --force pip &&\
  pip install nflx-genie-client==2.0.0

# Put the example scripts onto the image if people want to use them
ADD hadoop/2.6.0/conf/*.xml /apps/genie/hadoop/2.6.0/conf/
ADD example/*.py /apps/genie/example/

EXPOSE 8080

ENTRYPOINT ["/tomcat/bin/catalina.sh"]

CMD ["run"]
