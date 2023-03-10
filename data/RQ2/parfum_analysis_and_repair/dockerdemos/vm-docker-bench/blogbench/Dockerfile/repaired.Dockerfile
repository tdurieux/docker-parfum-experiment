# Docker image for testing file I/O
# operations simulating a real-world
# server, using Blogbench
#
# http://download.pureftpd.org/pub/blogbench/blogbench-1.1.tar.gz

FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y wget tar gcc && rm -rf /var/cache/yum
RUN wget https://download.pureftpd.org/pub/blogbench/blogbench-1.1.tar.gz
RUN tar xvzf blogbench-1.1.tar.gz && rm blogbench-1.1.tar.gz
RUN /blogbench-1.1/configure
RUN make
RUN make install

ENTRYPOINT ["/usr/local/bin/blogbench"]
CMD ["--help"]
