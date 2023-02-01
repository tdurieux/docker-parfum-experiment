FROM centos:latest


MAINTAINER Oleg Strizhechenko version: 0.1

RUN yum -y install epel-release && yum -y update && rm -rf /var/cache/yum
RUN yum -y install ruby-devel gcc make rpm-build rubygems python-pip && rm -rf /var/cache/yum
RUN gem install --no-ri --no-rdoc fpm
ADD netutils.sh /root/netutils.sh
RUN pip install --no-cache-dir setuptools

CMD ["/bin/bash"]
