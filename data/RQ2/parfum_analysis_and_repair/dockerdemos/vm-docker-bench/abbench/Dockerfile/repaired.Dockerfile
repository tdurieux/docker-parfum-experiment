# Docker image for running Apache 
# benchmark tests.

FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y httpd-tools && rm -rf /var/cache/yum

ENTRYPOINT ["/usr/bin/ab"]
CMD ["--help"]
