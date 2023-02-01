FROM centos:@@@TAG_NAME@@@
RUN yum install -y curl openssl perl && rm -rf /var/cache/yum
