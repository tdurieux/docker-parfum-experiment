FROM centos:7

MAINTAINER crunchy

RUN yum install -y epel-release tar wget java gcc make ruby ruby-devel procps-ng unzip openssh-clients hostname bind-utils && yum clean all -y

ADD kibana.tar.gz /

ADD elasticsearch.tar.gz /

RUN mkdir -p /elasticsearch/logs \
	/elasticsearch/plugins \
	/elasticsearch/nodes 

RUN useradd elasticsearch
RUN chown -R elasticsearch /elasticsearch

VOLUME ["/elasticsearch/data"]

RUN gem install fluentd --no-ri --no-rdoc
RUN fluent-gem install fluent-plugin-elasticsearch --no-ri --no-rdoc

RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf
ADD bin /var/cpm/bin
ADD sbin /var/cpm/bin
ADD conf /var/cpm/conf
#ADD conf/listen.conf /etc/rsyslog.d/listen.conf

USER root

CMD ["/var/cpm/bin/start-efk.sh"]
