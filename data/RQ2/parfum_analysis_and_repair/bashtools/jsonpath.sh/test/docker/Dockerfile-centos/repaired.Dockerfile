FROM centos

RUN yum -y install python2 diffutils which && rm -rf /var/cache/yum
