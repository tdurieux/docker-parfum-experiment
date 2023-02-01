FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install net-snmp net-snmp-utils -y && rm -rf /var/cache/yum

COPY etc /etc
COPY root /root
RUN chmod +x /root/*.sh

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
