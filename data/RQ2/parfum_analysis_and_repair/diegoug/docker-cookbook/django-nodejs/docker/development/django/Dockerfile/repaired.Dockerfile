FROM centos:centos7
MAINTAINER diego.uribe.gamez@gmail.com

RUN yum -y update

RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install gcc gcc-c++ && rm -rf /var/cache/yum
RUN yum -y install postgresql postgresql-devel python-psycopg2 && rm -rf /var/cache/yum
RUN yum -y install python34 python34-setuptools python34-devel && rm -rf /var/cache/yum

RUN yum clean all

RUN easy_install-3.4 pip

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
RUN rm -f /tmp/requirements.txt
