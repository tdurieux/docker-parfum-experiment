# Creates distributed cdh5
# docker build -t supermy/alpine-cdh5:snappy alpine

FROM supermy/docker-jre:ap

MAINTAINER JamesMo <springclick@gmail.com>

#RUN sed -i '1,3d'   /etc/apt/sources.list

RUN sed -i '1a \
deb http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
  deb http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
deb http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
  deb-src http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
deb-src http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
  deb-src http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
' /etc/apt/sources.list



USER root

# home
RUN mkdir -p /home/jamesmo

# tools
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl sudo supervisor apt-transport-https openssl

#RUN sed -i '1,3d'   /etc/apt/sources.list

# install hadoop
RUN curl -O http://archive.cloudera.com/cdh5/one-click-install/wheezy/amd64/cdh5-repository_1.0_all.deb
  RUN dpkg -i cdh5-repository_1.0_all.deb
RUN curl -s http://archive.cloudera.com/cdh5/debian/wheezy/amd64/cdh/archive.key | sudo apt-key add -
  RUN curl http://archive.cloudera.com/gplextras5/debian/wheezy/amd64/gplextras/cloudera.list -o /etc/apt/sources.list.d/cloudera.list
RUN DEBIAN_FRONTEND=noninteractive  apt-get update -y && apt-get install -y hadoop-hdfs-namenode hadoop-hdfs-datanode zookeeper \
hadoop-lzo*   \
hadoop-yarn hadoop-yarn-nodemanager hadoop-mapreduce

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y snappy spark
