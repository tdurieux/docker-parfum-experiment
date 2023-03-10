FROM centos:latest

RUN mkdir -p /app; \
    yum install -y createrepo make rpm-build epel-release; rm -rf /var/cache/yum \
    yum install -y python2-mock
ADD . /app
WORKDIR /app
ENTRYPOINT ["/usr/bin/make"]
