FROM centos:latest

RUN yum install which -y && rm -rf /var/cache/yum

RUN rpm --import http://packages.wazuh.com/key/GPG-KEY-WAZUH
COPY wazuh-repository.txt /etc/yum.repos.d/wazuh.repo

RUN yum install wazuh-agent-3.5.0 -y && rm -rf /var/cache/yum

COPY entrypoint.sh /scripts/entrypoint.sh
