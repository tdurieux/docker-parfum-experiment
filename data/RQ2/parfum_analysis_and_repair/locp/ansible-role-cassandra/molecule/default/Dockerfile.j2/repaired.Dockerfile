# Molecule managed

{% if item.image == 'centos:7' %}
#
# CentOS 7
#
FROM {{ item.image }}

RUN yum makecache fast \
  && yum install -y python sudo yum-plugin-ovl bash epel-release \
  && yum install -y iproute initscripts \
  && yum clean all && rm -rf /var/cache/yum
{% elif item.image == 'centos:8' %}
#
# CentOS 8 Stream
#
FROM quay.io/centos/centos:stream8
RUN yum install -y dnf \
  && yum clean all \
  && rm -f /etc/yum.repos.d/epel-*.repo /etc/yum.repos.d/CentOS-Extras.repo \
  && dnf makecache \
  && dnf --assumeyes install python36 sudo python36-devel python*-dnf bash iproute initscripts java-1.8.0-openjdk-headless \
  && dnf clean all && rm -rf /var/cache/yum
{% elif item.image == 'centos:latest' %}
#
# CentOS (latest)
#
FROM quay.io/centos/centos:stream8

RUN yum install -y dnf \
  && yum clean all \
  && rm -f /etc/yum.repos.d/epel-*.repo /etc/yum.repos.d/CentOS-Extras.repo \
  && dnf makecache \
  && dnf --assumeyes install python36 sudo python36-devel python*-dnf bash iproute initscripts java-1.8.0-openjdk-headless \
  && dnf clean all && rm -rf /var/cache/yum
{% elif item.image == 'debian:10' %}
#
# Debian 10
#
FROM {{ item.image }}

RUN apt-get clean
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python-apt python3-apt sudo bash ca-certificates lsb-release procps \
  || apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python-apt python3-apt sudo bash ca-certificates lsb-release procps && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list
RUN apt-get clean \
    && apt-get update \
    && apt-get install --no-install-recommends -y --fix-missing zulu-8 \
    || apt-get install --no-install-recommends -y --fix-missing zulu-8 && rm -rf /var/lib/apt/lists/*;
{% elif item.image == 'debian:11' %}
#
# Debian 11
#
FROM {{ item.image }}

RUN apt-get clean
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils gnupg2 python3-apt sudo bash ca-certificates lsb-release procps iproute2 \
  || apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils gnupg2 python3-apt sudo bash ca-certificates lsb-release procps iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list
RUN apt-get clean \
    && apt-get update \
    && apt-get install --no-install-recommends -y --fix-missing zulu-8 \
    || apt-get install --no-install-recommends -y --fix-missing zulu-8 && rm -rf /var/lib/apt/lists/*;
{% elif item.image == 'debian:stable' %}
#
# Debian (latest)
#
FROM {{ item.image }}

RUN apt-get clean
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils gnupg2 python3-apt sudo bash ca-certificates lsb-release procps iproute2 \
  || apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils gnupg2 python3-apt sudo bash ca-certificates lsb-release procps iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list
RUN apt-get clean \
    && apt-get update \
    && apt-get install --no-install-recommends -y --fix-missing zulu-8 \
    || apt-get install --no-install-recommends -y --fix-missing zulu-8 && rm -rf /var/lib/apt/lists/*;
{% elif item.image == 'fedora:34' %}
#
# Fedora 34
#
FROM {{ item.image }}

RUN dnf makecache \
  && dnf --assumeyes install jre \
  && alternatives --remove-all java \
  && alternatives --remove-all jre_openjdk \
  && dnf --assumeyes install python sudo python-devel python*-dnf bash systemd chkconfig initscripts iproute java-1.8.0-openjdk-headless \
  && dnf clean all
{% elif item.image == 'fedora:latest' %}
#
# Fedora (latest)
#
FROM {{ item.image }}

RUN dnf makecache \
  && dnf --assumeyes install jre \
  && alternatives --remove-all java \
  && alternatives --remove-all jre_openjdk \
  && dnf --assumeyes install python sudo python-devel python*-dnf bash systemd chkconfig initscripts iproute java-1.8.0-openjdk-headless \
  && dnf clean all
{% elif item.image == 'ubuntu:18.04' or item.image == 'ubuntu:20.04' %}
#
# Ubuntu 18.04 and 20.04.
#
FROM {{ item.image }}

RUN apt-get clean
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python-apt python3-apt sudo bash ca-certificates iproute2 \
  || apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python-apt python3-apt sudo bash ca-certificates iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
{% elif item.image == 'ubuntu:latest' %}
#
# Ubuntu (Latest)
#
FROM {{ item.image }}

RUN apt-get clean
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python3-apt sudo bash ca-certificates iproute2 gpg \
  || apt-get install --no-install-recommends -y --fix-missing apt-transport-https apt-utils python3-apt sudo bash ca-certificates iproute2 gpg && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
{% else %}
UNSUPPORTED_LINUX_DISTRIBUTION
{% endif %}
