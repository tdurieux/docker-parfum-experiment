FROM centos:centos7
MAINTAINER diego.uribe.gamez@gmail.com

RUN yum -y update

RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install gcc gcc-c++ && rm -rf /var/cache/yum
RUN yum -y install mariadb mariadb-devel MySQL-python && rm -rf /var/cache/yum

RUN yum -y install python-devel python-setuptools python-pip && rm -rf /var/cache/yum
RUN pip install --no-cache-dir --upgrade pip

RUN yum clean all

COPY app/ /opt/app/
RUN pip install --no-cache-dir -r /opt/app/requirements.txt