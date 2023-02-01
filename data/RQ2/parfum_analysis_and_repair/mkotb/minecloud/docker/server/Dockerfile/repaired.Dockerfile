FROM centos:centos6
MAINTAINER Mazen Kotb

RUN yum -y install wget gcc openssl openssl-devel && rm -rf /var/cache/yum
RUN yum -y install java-1.8.0-openjdk-headless.x86_64 && rm -rf /var/cache/yum

RUN mkdir /minecloud
ADD initialize.sh /minecloud/initialize.sh

EXPOSE 25565

WORKDIR /minecloud
ENTRYPOINT ["sh", "initialize.sh"]