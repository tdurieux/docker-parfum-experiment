FROM centos:7

#for command envsubst
RUN yum install -y gettext && rm -rf /var/cache/yum

RUN mkdir -p /data/bcs/logs/bcs /data/bcs/cert
RUN mkdir -p /data/bcs/bcs-gamestatefulset-operator/

ADD bcs-gamestatefulset-operator /data/bcs/bcs-gamestatefulset-operator/
ADD container-start.sh /data/bcs/bcs-gamestatefulset-operator/

RUN chmod +x /data/bcs/bcs-gamestatefulset-operator/bcs-gamestatefulset-operator
RUN chmod +x /data/bcs/bcs-gamestatefulset-operator/container-start.sh

WORKDIR /data/bcs/bcs-gamestatefulset-operator/
CMD [ "/data/bcs/bcs-gamestatefulset-operator/container-start.sh" ]
