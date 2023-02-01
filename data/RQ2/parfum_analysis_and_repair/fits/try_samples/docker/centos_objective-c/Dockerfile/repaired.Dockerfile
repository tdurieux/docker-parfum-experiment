FROM centos

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install clang make gcc-objc gnustep-base-devel && rm -rf /var/cache/yum

RUN yum clean all
