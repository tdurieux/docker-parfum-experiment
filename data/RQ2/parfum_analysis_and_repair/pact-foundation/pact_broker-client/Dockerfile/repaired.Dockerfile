FROM ruby:3.1-alpine

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub
RUN apk add --update --no-cache git openssh bash
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;

RUN mkdir -p home
WORKDIR home
ADD release-image /
ENV BUNDLE_GEMFILE=/release/Gemfile
RUN bundle install
RUN git config --global user.email "beth@bethesque.com"
RUN git config --global user.name "Beth Skurrie via Github Actions"

ENTRYPOINT [/entrypoint.sh]
