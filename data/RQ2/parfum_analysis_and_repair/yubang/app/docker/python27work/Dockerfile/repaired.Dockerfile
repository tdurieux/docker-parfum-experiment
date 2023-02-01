# python环境，v1, python2.7
FROM centos:7

MAINTAINER yubang（yubang93@gmail.com）

RUN yum install epel-release -y && rm -rf /var/cache/yum

RUN yum -y install mysql-devel && rm -rf /var/cache/yum
RUN yum install python2-pip -y && rm -rf /var/cache/yum
RUN mkdir -v ~/.pip && echo -e "[global]\ntimeout = 60\nindex-url = https://pypi.douban.com/simple" > ~/.pip/pip.conf

ADD install.sh /var/install.sh
ADD start.sh /var/start.sh
