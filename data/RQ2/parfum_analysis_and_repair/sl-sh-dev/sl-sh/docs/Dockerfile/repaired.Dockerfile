ARG RUBY=2.7.1
FROM ruby:$RUBY

EXPOSE 4000

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    locales \
    make \
    nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update system && rm -rf /root/.gem;

COPY Gemfile /tmp/
RUN bundle config local.ghpages /tmp/ && NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install --gemfile=/tmp/Gemfile

RUN echo "en_US UTF-8" > /etc/locale.gen && locale-gen en-US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp/
COPY . /tmp/
ENTRYPOINT ["jekyll", "serve", "--config", "/tmp/_config.yml,/tmp/_user_config.yml", "--livereload", "-H", "0.0.0.0", "-p", "4000"]
