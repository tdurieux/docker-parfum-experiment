FROM centos:7
MAINTAINER Tim Marcinowski <marshyski@gmail.com>

RUN yum -y update
RUN yum install -y createrepo && yum clean all && rm -rf /var/cache/yum
RUN mkdir -p /repo
ADD ./yumapi.yaml /
ADD ./yumapi /

EXPOSE 8080

CMD ["/yumapi"]