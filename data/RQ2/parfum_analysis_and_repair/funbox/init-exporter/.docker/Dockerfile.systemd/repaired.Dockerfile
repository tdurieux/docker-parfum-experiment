FROM centos:centos7

ENV GOPATH /root
ENV TARGET /root/src/github.com/funbox/init-exporter

RUN yum install -y https://yum.kaos.st/kaos-repo-latest.el7.noarch.rpm && rm -rf /var/cache/yum
RUN yum clean all && yum -y update

RUN yum -y install make golang && rm -rf /var/cache/yum

COPY . $TARGET
RUN ls $TARGET -al
RUN cd $TARGET && make all && make install

RUN useradd service
RUN mkdir -p /var/local/init-exporter/helpers && mkdir -p /var/log/init-exporter

COPY ./testdata /root

RUN yum clean all && rm -rf /tmp/*

WORKDIR /root
