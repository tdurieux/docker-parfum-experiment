FROM stackbrew/centos:centos6
MAINTAINER Mesosphere support@mesosphere.io

RUN yum -y install wget && rm -rf /var/cache/yum
RUN wget https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
  wget https://rpms.famillecollet.com/enterprise/remi-release-6.rpm && \
  rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
RUN yum -y groupinstall "Development tools"
RUN yum -y install \
  make \
  protobuf-devel \
  python-setuptools \
  centos-release-SCL \
  rubygems \
  ruby-devel && rm -rf /var/cache/yum
RUN yum -y install \
  python27 && rm -rf /var/cache/yum
RUN gem install fpm
RUN scl enable python27 "easy_install bbfreeze"

WORKDIR /container
ENTRYPOINT ["scl"]
CMD ["enable", "python27", "make rpm"]
