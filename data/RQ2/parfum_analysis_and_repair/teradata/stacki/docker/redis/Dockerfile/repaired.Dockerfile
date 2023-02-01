FROM centos:7
WORKDIR /tmp

EXPOSE 6379

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y python2-pip redis && rm -rf /var/cache/yum
RUN pip install --no-cache-dir j2cli
RUN pip install --no-cache-dir j2cli[yaml]

COPY redis.conf.j2 .
COPY start.sh      /

CMD ["/bin/bash", "/start.sh"]
