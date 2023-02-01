FROM centos:latest

MAINTAINER Paolo Antinori <paolo.antinori@gmail.com>

RUN yum install -y httpd ; rm -rf /var/cache/yum yum -y clean all

CMD service httpd start ; bash

EXPOSE 80