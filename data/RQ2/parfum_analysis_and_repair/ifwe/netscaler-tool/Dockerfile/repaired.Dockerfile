FROM centos:7

RUN yum update -y && yum install python-setuptools -y && rm -rf /var/cache/yum

RUN mkdir /var/log/netscaler-tool
RUN touch /var/log/netscaler-tool/netscaler-tool.log

COPY netscalertool.conf.example /etc/netscalertool.conf
