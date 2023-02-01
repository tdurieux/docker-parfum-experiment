FROM centos:centos7

RUN curl -f https://dl.google.com/go/go1.18.linux-amd64.tar.gz | tar xzvf - -C /usr/local
RUN yum install -y make rpm-build git createrepo python3 gcc && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir awscli
ENV PATH=$PATH:/usr/local/go/bin

CMD ["/bin/sh"]
