FROM centos:7

MAINTAINER yubang（yubang93@gmail.com ）

RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install nginx -y && rm -rf /var/cache/yum
ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /var/start.sh
