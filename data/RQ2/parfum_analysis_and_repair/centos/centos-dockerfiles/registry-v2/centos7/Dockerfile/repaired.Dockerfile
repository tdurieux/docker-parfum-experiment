FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y install docker-distribution; rm -rf /var/cache/yum yum clean all

EXPOSE 5000

USER 42

ENTRYPOINT ["/usr/bin/registry"]
CMD ["/etc/docker-distribution/registry/config.yml"]
