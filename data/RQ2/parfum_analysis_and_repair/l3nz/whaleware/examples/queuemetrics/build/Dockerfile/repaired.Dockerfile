FROM lenz/whaleware:200630a

EXPOSE 8080

RUN yum install -y wget lsof nano tar jq && \
    wget -P /etc/yum.repos.d https://yum.loway.ch/loway.repo && \
    yum install -y queuemetrics && rm -rf /var/cache/yum

ADD ./ww /ww

