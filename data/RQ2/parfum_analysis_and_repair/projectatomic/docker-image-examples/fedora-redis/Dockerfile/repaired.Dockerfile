FROM fedora
MAINTAINER Mrunal Patel <mpatel@redhat.com>

RUN yum install redis -y && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /var/lib/redis && \
    chown redis.redis /var/lib/redis && \
    touch /var/lib/redis/.keep

VOLUME ["/var/lib/redis"]

EXPOSE 6379

USER redis

CMD  ["/usr/sbin/redis-server"]
