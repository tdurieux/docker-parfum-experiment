ARG RUBY_VERSION=2.7.3
FROM ruby:$RUBY_VERSION

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
    locales \
    make \
    nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;

COPY .git /src/gh/pages-gem/.git
COPY Gemfile* /src/gh/pages-gem/
COPY github-pages.gemspec /src/gh/pages-gem
COPY lib/ /src/gh/pages-gem/lib
COPY bin/ /src/gh/pages-gem/bin

RUN \
  bundle config local.github-pages /src/gh/pages-gem && \
  NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install --gemfile=/src/gh/pages-gem/Gemfile

COPY . /src/gh/pages-gem

RUN \
  echo "en_US UTF-8" > /etc/locale.gen && \
  locale-gen en-US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /src/site

CMD ["jekyll", "serve", "-H", "0.0.0.0", "-P", "4000"]
