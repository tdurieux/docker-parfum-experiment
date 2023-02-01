FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install -y bind && rm -rf /var/cache/yum

COPY etc /etc
COPY root /root
RUN chmod +x /root/*.sh

EXPOSE 53
ENTRYPOINT ["/bin/bash", "/root/start.sh"]
