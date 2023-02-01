FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum install -y curl && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
