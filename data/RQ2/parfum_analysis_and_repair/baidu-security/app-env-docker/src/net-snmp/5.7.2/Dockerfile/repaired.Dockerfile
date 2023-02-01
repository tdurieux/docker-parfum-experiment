FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install -y net-snmp net-snmp-utils && rm -rf /var/cache/yum

COPY snmpd.conf /etc/snmp/
COPY *.sh /root/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
EXPOSE 161

