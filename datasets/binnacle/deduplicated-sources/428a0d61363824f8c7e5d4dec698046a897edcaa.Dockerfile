FROM centos
MAINTAINER tim@cyface.com

RUN yum install -y epel-release && \
    yum install -y --nogpgcheck https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm && \
    yum update -y && \
    yum install -y virt-what salt-master && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN sed -i "s|#auto_accept: False|auto_accept: True|g" /etc/salt/master

ENTRYPOINT ["salt-master", "-l", "debug"]
