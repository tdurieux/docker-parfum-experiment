FROM centos:centos7

#for command envsubst
RUN yum install -y gettext && rm -rf /var/cache/yum

RUN mkdir -p /data/bcs/logs/bcs /data/bcs/cert/bcs
RUN mkdir -p /data/bcs/bcs-gateway-discovery/

ADD container-start.sh /data/bcs/bcs-gateway-discovery/
ADD bcs-gateway-discovery.json.template /data/bcs/bcs-gateway-discovery/
ADD bcs-gateway-discovery /data/bcs/bcs-gateway-discovery/
RUN chmod +x /data/bcs/bcs-gateway-discovery/container-start.sh

WORKDIR /data/bcs/bcs-gateway-discovery/
CMD ["/data/bcs/bcs-gateway-discovery/container-start.sh"]

