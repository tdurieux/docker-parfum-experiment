FROM quay.io/centos/centos:stream8

RUN yum install -y initscripts && rm -rf /var/cache/yum# for old "service"

ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

COPY linux/nginx.repo /etc/yum.repos.d/nginx.repo
#COPY linux/nginx.repo /etc/yum.repos.d/nginx.repo

RUN dnf install yum-utils epel-release -y && \
	dnf install nginx-1.20.2 -y

VOLUME /run /tmp

CMD /usr/sbin/init