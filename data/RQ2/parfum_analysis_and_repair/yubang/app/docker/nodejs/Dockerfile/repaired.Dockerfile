# python环境，v1, nginx, nodejs
FROM centos:7

MAINTAINER yubang（yubang93@gmail.com）

RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install nginx -y && rm -rf /var/cache/yum

RUN yum install -y nodejs && rm -rf /var/cache/yum

ADD nginx.conf /etc/nginx/nginx.conf
ADD install.sh /var/install.sh
ADD start.sh /var/start.sh
