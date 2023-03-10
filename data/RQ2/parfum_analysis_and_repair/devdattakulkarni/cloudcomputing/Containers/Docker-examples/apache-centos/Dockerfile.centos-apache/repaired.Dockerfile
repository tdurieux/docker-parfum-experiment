FROM centos:7
MAINTAINER "Scott Collier" <scollier@redhat.com>

# https://github.com/projectatomic/docker-image-examples/blob/master/rhel-httpd/Dockerfile

RUN yum -y update; yum clean all
RUN yum -y install httpd; rm -rf /var/cache/yum yum clean all
RUN echo "Apache" >> /var/www/html/index.html

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-apache.sh /run-apache.sh
RUN chmod -v +x /run-apache.sh

CMD ["/run-apache.sh"]