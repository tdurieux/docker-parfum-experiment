FROM fedora

MAINTAINER STANLEY

RUN yum -y update
RUN yum install -y curl && rm -rf /var/cache/yum
