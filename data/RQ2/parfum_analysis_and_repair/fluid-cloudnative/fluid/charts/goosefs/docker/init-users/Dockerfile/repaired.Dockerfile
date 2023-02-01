FROM centos:centos8.2.2004

RUN yum install -y net-tools && rm -rf /var/cache/yum

COPY *.sh /

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]
