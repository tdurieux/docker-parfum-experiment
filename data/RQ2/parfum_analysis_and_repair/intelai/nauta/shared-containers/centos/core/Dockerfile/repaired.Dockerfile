FROM centos:7.6.1810

RUN yum update -y && yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum-config-manager --enable centos-sclo-rh-testing
RUN yum install -y epel-release && rm -rf /var/cache/yum

CMD ["/bin/bash"]
