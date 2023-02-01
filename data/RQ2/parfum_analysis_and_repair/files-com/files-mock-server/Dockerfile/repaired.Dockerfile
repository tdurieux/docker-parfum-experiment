FROM ruby:2.5
MAINTAINER Action Verb, LLC "https://github.com/Files-com"

ADD . /files-mock-server
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system \
  && cd files-mock-server \
  && bundle install && rm -rf /root/.gem;

EXPOSE 4041
WORKDIR files-mock-server
ENTRYPOINT ["bundle", "exec", "puma"]
