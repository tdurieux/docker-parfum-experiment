# Forked from jplock/zookeeper (https://index.docker.io/u/jplock/zookeeper/)

FROM ubuntu:14.04
MAINTAINER viki-data data@viki.com

RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ccs.neu.edu/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y unzip openjdk-6-jre-headless wget supervisor python-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir PyYAML==3.11

RUN wget -q -O /opt/zookeeper-3.4.6.tar.gz https://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
RUN tar -xzf /opt/zookeeper-3.4.6.tar.gz -C /opt && rm /opt/zookeeper-3.4.6.tar.gz
RUN rm /opt/zookeeper-3.4.6.tar.gz
# Create Zookeeper snapshot directory (dataDir)
ENV ZK_DATADIR /var/lib/zookeeper
RUN mkdir -p $ZK_DATADIR
# Create Zookeeper transaction log directory (dataLogDir)
RUN mkdir /zookeeper-transactions
# Add custom Zookeeper configuration file
ENV ZK_CFG /opt/zookeeper-3.4.6/conf/zoo.cfg
ADD zoo.cfg $ZK_CFG
# Disable Zookeeper `dataDir` autocreation, read:
#     http://zookeeper.apache.org/doc/trunk/zookeeperAdmin.html#Disabling+data+directory+autocreation
ENV ZOO_DATADIR_AUTOCREATE_DISABLE 1

# Add storm-setup.yaml to get Zookeeper IP addresses
ENV STORM_SETUP_YAML /storm-setup.yaml
ADD storm-setup.yaml $STORM_SETUP_YAML

# Logs folder for supervisord
RUN mkdir -p /var/log/supervisor

# Append supervisord global settings to /etc/supervisor/supervisord.conf
RUN echo [supervisord] | tee -a /etc/supervisor/supervisord.conf
RUN echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf

# Add supervisor configuration file for zookeeper
ADD zookeeper.supervisord.conf /etc/supervisor/conf.d/zookeeper.conf

ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64

# SSH
RUN mkdir /var/run/sshd
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN echo 'root:root' | chpasswd
RUN sed -i 's/^\(PermitRootLogin\).*$/\1 yes/' /etc/ssh/sshd_config
RUN sed -i 's/^\(.*pam_loginuid\.so.*\)$/#\1/' /etc/pam.d/sshd
ADD ssh.supervisord.conf /etc/supervisor/conf.d/ssh.conf
EXPOSE 22

# Entrypoint
ADD run-zookeeper.py /usr/bin/run-zookeeper.py

ENTRYPOINT ["/usr/bin/run-zookeeper.py"]
