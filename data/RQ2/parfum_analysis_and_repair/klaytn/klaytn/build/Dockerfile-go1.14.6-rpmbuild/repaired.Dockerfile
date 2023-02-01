FROM centos:centos7

RUN curl -f https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz | tar xzvf - -C /usr/local
RUN yum install -y make rpm-build git createrepo awscli gcc && rm -rf /var/cache/yum
ENV PATH=$PATH:/usr/local/go/bin

CMD ["/bin/sh"]
