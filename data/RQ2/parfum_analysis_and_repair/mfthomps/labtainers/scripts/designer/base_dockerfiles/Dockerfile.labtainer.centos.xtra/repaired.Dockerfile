ARG registry
FROM $registry/labtainer.centos
LABEL description="This is the extended base Docker image for Labtainer CentOS images"
RUN yum install -y liberation-sans-fonts xcb-util && rm -rf /var/cache/yum
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/l/leafpad-0.8.18.1-1.el6.x86_64.rpm && rm -rf /var/cache/yum
ADD system/usr/share/man/man1.tar /usr/share/man
RUN mandb
# CFS: it will end up in /usr/sbin anyway.  no idea why.  so hack up a unique waitparam.service
ADD system/sbin/waitparam.sh /usr/sbin/waitparam.sh
ADD system/lib/systemd/system/waitparam.service.cfs /lib/systemd/system/waitparam.service
RUN systemctl enable waitparam.service
# work around centos base having old yum-source.sh and  sources in /tmp instead of /var/tmp
ADD system/bin/yum-source.sh /usr/bin/yum-source.sh
RUN mkdir /var/tmp/yum.repos.d
RUN mv /tmp/yum.repos.d/* /var/tmp/yum.repos.d/

