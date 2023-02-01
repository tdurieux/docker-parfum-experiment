FROM openrasp/centos7

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install subversion mod_dav_svn -y && rm -rf /var/cache/yum

COPY /root /

EXPOSE 80
ENTRYPOINT ["/bin/bash", "/root/start.sh"]
