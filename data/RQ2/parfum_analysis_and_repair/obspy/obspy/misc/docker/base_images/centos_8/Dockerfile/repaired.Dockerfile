FROM centos:centos8

MAINTAINER Tobias Megies

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
# Can fail on occasion.
RUN yum -y upgrade || true
RUN yum install -y gcc numpy scipy python-matplotlib python-sqlalchemy python-lxml python-mock python-basemap python-basemap-data python-pip python-requests python-decorator && rm -rf /var/cache/yum
RUN easy_install -U pip
RUN pip install --no-cache-dir future
RUN pip install --no-cache-dir https://github.com/Damgaard/PyImgur/archive/9ebd8bed9b3d0ae2797950876f5c1e64a560f7d8.zip
# Force agg.
RUN mkdir -p /root/.matplotlib && echo "backend: agg" > /root/.matplotlib/matplotlibrc
