# Notable references
# - http://www.projectatomic.io/blog/2014/09/running-syslog-within-a-docker-container/

FROM centos:7
LABEL application="rsyslog_test_client_centos7"

ENV container=docker

# Setup repos, etc
# Disable fast mirror plugin to better leverage upstream proxy caching (or use specific repos)
# Switch yum config to use a consitant base url (useful if not caching docker build, but relying on an upstream proxy)
ARG DISABLE_YUM_MIRROR=false
RUN if [ "$DISABLE_YUM_MIRROR" != true ]; then exit; fi && \
  sed 's/enabled=1/enabled=0/g' -i /etc/yum/pluginconf.d/fastestmirror.conf && \
  sed 's/^mirrorlist/#mirrorlist/g' -i /etc/yum.repos.d/CentOS-Base.repo && \
  sed 's/^#baseurl/baseurl/g' -i /etc/yum.repos.d/CentOS-Base.repo

# Install default rsyslog packages and redhat-lsb-core
RUN yum --setopt=timeout=120 -y update && \
  yum --setopt=timeout=120 --setopt=tsflags=nodocs -y install \
  rsyslog \
  rsyslog-relp \
  && yum clean all && rm -rf /var/cache/yum
RUN rm -r /etc/rsyslog.d/ \
  && rm /etc/rsyslog.conf
COPY centos7/etc /etc

RUN mkdir -p usr/local/etc/pki/test

COPY rsyslog_test_client.sh /usr/local/bin
RUN chmod +x /usr/local/bin/rsyslog_test_client.sh

VOLUME /var/lib/rsyslog

ENTRYPOINT ["/usr/local/bin/rsyslog_test_client.sh"]
