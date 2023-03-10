{% if 'centos' in version %}
FROM centos:7

RUN \
  rpm -i http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
  yum -y install chronos-2.4.0 mesos-0.24.1 && rm -rf /var/cache/yum
{% elif 'ubuntu' in version %}
FROM ubuntu:14.04

RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
  echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
  apt-get update && \
  apt-get -y --no-install-recommends install chronos=2.4.0-0.1.20150828104228.ubuntu1404 mesos=0.24.1-0.2.35.ubuntu1404 && rm -rf /var/lib/apt/lists/*;
{% endif %}

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
