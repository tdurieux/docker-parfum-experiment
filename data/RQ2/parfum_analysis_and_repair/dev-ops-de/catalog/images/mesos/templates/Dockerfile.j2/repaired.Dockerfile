{% if 'centos' in version %}
FROM centos:7

RUN rpm -i http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
yum -y install mesos-0.24.1 && rm -rf /var/cache/yum
{% elif 'ubuntu' in version %}
FROM ubuntu:14.04

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
apt-get update && \
 apt-get -y --no-install-recommends install mesos=0.24.1-0.2.35.ubuntu1404 curl && rm -rf /var/lib/apt/lists/*;
{% endif %}

{% if type == 'slave' %}
RUN curl -fLsS https://get.docker.com/ | sh

ENV MESOS_CONTAINERIZERS docker,mesos

# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins
{% endif %}

ENV MESOS_WORK_DIR /data

VOLUME /data

ADD {{ entrypoint }} /

ENTRYPOINT ["/{{ entrypoint }}"]
