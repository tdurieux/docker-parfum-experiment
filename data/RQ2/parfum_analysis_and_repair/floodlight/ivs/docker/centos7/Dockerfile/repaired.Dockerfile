FROM centos:centos7
MAINTAINER Rich Lane <rlane@bigswitch.com>
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y libnl3-devel && rm -rf /var/cache/yum
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y ccache && rm -rf /var/cache/yum
RUN yum install -y libcap-devel && rm -rf /var/cache/yum
RUN yum install -y libpcap-devel && rm -rf /var/cache/yum
RUN yum install -y openssl-devel && rm -rf /var/cache/yum
