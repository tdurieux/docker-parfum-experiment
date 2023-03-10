#
# About: Image for FlowVisor: A transparent proxy between OpenFlow switches and multiple OpenFlow controllers
# Ref  : https://github.com/fernnf/vsdnemul
#
# WARN : The last commit for FlowVisor is on Aug 31, 2013... The chosen of this old crap is due to lacking of alternative.
#

FROM centos:6.10

RUN yum update -y && yum install wget sudo nano -y && rm -rf /var/cache/yum

WORKDIR /root

RUN wget https://updates.onlab.us/GPG-KEY-ONLAB

RUN rpm --import GPG-KEY-ONLAB

RUN echo -e "[onlab] \nname=ON.Lab Software Releases \nbaseurl=http://updates.onlab.us/rpm/stable \nenabled=1 \ngpgcheck=1" >> /etc/yum.repos.d/onlab.repo

RUN yum update -y

RUN yum install vim-enhanced -y && rm -rf /var/cache/yum

RUN yum install flowvisor -y && rm -rf /var/cache/yum

RUN fvconfig generate /etc/flowvisor/config.json flowvisor flowvisor

RUN sed -i 's/"run_topology_server": false/"run_topology_server": true/' /etc/flowvisor/config.json

RUN echo "flowvisor" > /etc/flowvisor/flowvisor.passwd

RUN chown flowvisor:flowvisor /etc/flowvisor/flowvisor.passwd

RUN fvconfig load /etc/flowvisor/config.json

RUN sed -i -e "s/\/sbin\/flowvisor /\/sbin\/flowvisor -l /ig" /etc/init.d/flowvisor

ENV TERM=vt100

ENV HOME /root

ENV BUILD_NUMBER docker

RUN fvconfig load /etc/flowvisor/config.json && \
    chown -R flowvisor:flowvisor /usr/share/db/flowvisor/

CMD ["bash"]
