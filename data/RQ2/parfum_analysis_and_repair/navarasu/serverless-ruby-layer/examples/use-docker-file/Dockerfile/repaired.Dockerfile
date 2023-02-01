FROM lambci/lambda:build-ruby2.7

RUN yum install -y postgresql-devel && rm -rf /var/cache/yum
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update bundler && rm -rf /root/.gem;

CMD "/bin/bash"
