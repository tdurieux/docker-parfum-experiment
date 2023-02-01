# iServStor
FROM ubuntu:16.04
MAINTAINER Docker Newbee yenkuanlee@gmail.com

RUN apt-get -qq update

# Basic tool
RUN apt-get -qqy --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install python python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install net-tools && rm -rf /var/lib/apt/lists/*; # ifconfig
RUN apt-get -qqy --no-install-recommends install python-pkg-resources && rm -rf /var/lib/apt/lists/*; # iservstor need it, only for ubuntu 14.04

# update java
RUN apt-get -qq update
RUN apt-get -qqy --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -qqy --no-install-recommends install openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# for iota
RUN apt-get -qqy --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip

#RUN apt-get -qqy install maven # long time ...
RUN apt-get -qq update

# for mcu
RUN apt-get -qqy --no-install-recommends install python3.5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -qqy --no-install-recommends install python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN easy_install3 pip
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get -qqy --no-install-recommends install solc && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir web3
RUN pip install --no-cache-dir py-solc
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen zh_TW zh_TW.UTF-8 zh_CN.UTF-8 en_US.UTF-8
RUN echo 'export LC_ALL=zh_TW.utf8' >> /root/.bashrc

# kevin
RUN pip2 install --no-cache-dir paho-mqtt
RUN pip3 install --no-cache-dir paho-mqtt
RUN pip2 install --no-cache-dir tensorflow
RUN pip3 install --no-cache-dir tensorflow
RUN chmod 755 /usr/local/bin/pip
RUN chmod 755 -R /usr/local/lib/python*/dist-packages

# tomcat
RUN cd /opt && wget https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz && tar xzf apache-tomcat-7.0.85.tar.gz && mv apache-tomcat-7.0.85 tomcat7 && echo 'export CATALINA_HOME="/opt/tomcat7"' >> ~/.bashrc && rm apache-tomcat-7.0.85.tar.gz

# somthing need
RUN apt-get -qqy --no-install-recommends install mosquitto && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install mosquitto-clients && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install psmisc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;

# Add localadmin user
RUN useradd -m localadmin && echo "localadmin:openstack" | chpasswd && adduser localadmin sudo
USER localadmin
RUN echo 'export LC_ALL=zh_TW.utf8' >> /home/localadmin/.bashrc

# clone IPDC project and setting
RUN cd && \
git clone https://github.com/yenkuanlee/IPDC

# VOltDB
RUN cd && \
wget https://github.com/VoltDB/voltdb/archive/voltdb-8.0.tar.gz && \
tar -zxf voltdb-8.0.tar.gz && \
mv voltdb-voltdb-8.0/ voltdb && \
cd voltdb && \
ant clean ; rm voltdb-8.0.tar.gz ant -Djmemcheck=NO_MEMCHECK && \
echo 'export CLASSPATH="$CLASSPATH:$HOME/voltdb/voltdb/*:$HOME/voltdb/lib/*:./"' >> /home/localadmin/.bashrc && \
echo 'alias voltdb="/home/localadmin/voltdb/bin/sqlcmd"' >> /home/localadmin/.bashrc && \
/home/localadmin/voltdb/bin/voltdb init


USER root
RUN cd /home/localadmin/IPDC && \
cp .ipfs/geth /usr/local/bin && \
chmod 755 /usr/local/bin/pip && \
chmod 755 -R /usr/local/lib/python2.7/dist-packages && \
service mosquitto restart

USER localadmin
RUN cd
