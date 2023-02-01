FROM rockylinux:latest
ARG project=minsky
ADD . /root
RUN yum install -y wget && rm -rf /var/cache/yum
RUN cd /etc/yum.repos.d/; wget https://download.opensuse.org/repositories/home:hpcoder1/CentOS_8/home:hpcoder1.repo
RUN yum install -y $project && rm -rf /var/cache/yum
RUN minsky /root/smoke.tcl

