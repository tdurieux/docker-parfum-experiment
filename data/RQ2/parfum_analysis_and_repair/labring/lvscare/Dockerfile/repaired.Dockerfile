FROM centos:7
RUN yum install -y ipvsadm && rm -rf /var/cache/yum
COPY lvscare /usr/bin/lvscare
CMD ["lvscare"]
