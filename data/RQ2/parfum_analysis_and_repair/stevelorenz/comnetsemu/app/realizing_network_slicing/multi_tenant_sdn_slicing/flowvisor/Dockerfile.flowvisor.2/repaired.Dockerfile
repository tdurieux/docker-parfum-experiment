FROM centos:6

RUN curl -f -LO http://updates.onlab.us/GPG-KEY-ONLAB
RUN rpm --import GPG-KEY-ONLAB
ADD onlab.repo  /etc/yum.repos.d/onlab.repo

COPY ./CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN curl -f https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo
RUN curl -f https://www.getpagespeed.com/files/centos6-epel-eol.repo --output /etc/yum.repos.d/epel.repo

RUN yum -y --disableplugin=fastestmirror --disableplugin=ovl install flowvisor sudo && rm -rf /var/cache/yum
#RUN sudo -u flowvisor fvconfig generate /etc/flowvisor/config.json
#RUN sudo -u flowvisor fvconfig generate /etc/flowvisor/config.json flowvisor admin
#RUN sudo -u flowvisor sed -i 's/"run_topology_server": false/"run_topology_server": true/' /etc/flowvisor/config.json

#CMD sudo -u flowvisor flowvisor

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
