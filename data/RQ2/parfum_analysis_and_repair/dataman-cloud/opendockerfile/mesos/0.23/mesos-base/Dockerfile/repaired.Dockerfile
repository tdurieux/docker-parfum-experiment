#FROM registry.shurenyun.com/centos7/base:omega.v0.2
FROM centos7/base
MAINTAINER upccup yyao@dataman-inc.com

#install curl
RUN yum -y install \
               curl && \

#add dataman repo
curl -f -o /etc/yum.repos.d/dataman.repo https://get.dataman-inc.com/repos/centos/7/0/dataman.repo && rm -rf /var/cache/yum


#install mesos-base
RUN yum install -y mesos-0.23.0 && yum clean all && rm -rf /var/cache/yum
