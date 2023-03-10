FROM centos:6
MAINTAINER matsumotory

RUN yum -y install --enablerepo=extras epel-release && rm -rf /var/cache/yum
RUN yum -y groupinstall "Development Tools"
#RUN yum -y install wget tar libcgroup-devel
RUN yum -y install wget tar pam-devel && rm -rf /var/cache/yum
RUN yum -y install openssl-devel && rm -rf /var/cache/yum
RUN yum -y install flex && rm -rf /var/cache/yum

RUN mkdir -p /opt/ruby-2.2.3/ && \
  curl -f -s https://s3.amazonaws.com/pkgr-buildpack-ruby/current/centos-6/ruby-2.2.3.tgz | tar xzC /opt/ruby-2.2.3/
ENV PATH /opt/ruby-2.2.3/bin:$PATH

WORKDIR /home/mruby/code
ENV GEM_HOME /home/mruby/code/.gem/

ENV PATH $GEM_HOME/bin/:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
