FROM centos:centos7
MAINTAINER mdye <mdye@us.ibm.com>

RUN yum install -y rsync && rm -rf /var/cache/yum
ADD docker /docker
RUN rsync -a /docker/fs/ /
RUN yum --enablerepo='epel-bootstrap' -y install epel-release && rm -rf /var/cache/yum

RUN yum install --nogpgcheck -y git nodejs npm fortune-mod && rm -rf /var/cache/yum

# do build, copy to installation dir
ADD . /src
RUN cd /src && npm install && npm cache clean --force;

EXPOSE 80

CMD ["/usr/local/bin/loggen_start"]
