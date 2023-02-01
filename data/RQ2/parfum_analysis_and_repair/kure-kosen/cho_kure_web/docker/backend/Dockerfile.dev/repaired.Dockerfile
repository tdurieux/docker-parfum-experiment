FROM ruby:2.4.5
LABEL maintainer="Kobatake Kazuhiro<@kobakazu0429>"

ENV LANG C.UTF-8

# noninteractive: インストール時にインタラクティブな入力待ちが発生しなくなる
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /code/

WORKDIR /code

# apt-get [-qq]: エラー以外は表示しない
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install --no-install-recommends -y libpq-dev graphviz imagemagick && \
    curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install --no-install-recommends -y nodejs build-essential && \
    gem install bundler --no-document --conservative && \
    gem update && rm -rf /root/.gem; && rm -rf /var/lib/apt/lists/*;

ADD Gemfile* /code/
ADD .env /code/

RUN bundle install -j4
