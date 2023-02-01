#FROM demoregistry.dataman-inc.com:5000/shurenyun/centos7-base:20160504103437
FROM centos7/base:20160504
MAINTAINER upccup yyao@dataman-inc.com

#install curl
RUN yum -y install \
               curl && \
              
#add -f da aman repo && rm -rf /var/cache/yum


#install mesos-base
RUN yum install -y mesos-0.25.1 && yum clean all && rm -rf /var/cache/yum
