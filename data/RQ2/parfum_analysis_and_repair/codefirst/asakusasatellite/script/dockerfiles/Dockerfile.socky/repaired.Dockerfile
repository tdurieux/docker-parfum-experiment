FROM ruby:2.6.5

WORKDIR /root

RUN gem install bundler && \
    mkdir -p /root/socky

COPY Gemfile Gemfile.lock socky/config.ru /root/

RUN bundle