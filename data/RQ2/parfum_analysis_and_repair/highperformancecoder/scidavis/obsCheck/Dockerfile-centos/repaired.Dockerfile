FROM centos:8
ARG project=scidavis
ADD . /root
RUN yum install -y wget && rm -rf /var/cache/yum
RUN cd /etc/yum.repos.d/; wget https://download.opensuse.org/repositories/home:hpcoder1/CentOS_8/home:hpcoder1.repo
RUN yum install -y $project xorg-x11-server-Xvfb && rm -rf /var/cache/yum
RUN sh /root/scidavisSmoke.sh

