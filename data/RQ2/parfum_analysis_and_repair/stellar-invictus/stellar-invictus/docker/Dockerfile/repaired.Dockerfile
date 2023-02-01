FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;

ENV RAILS_ENV 'development'
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update bundler && rm -rf /root/.gem;

RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile

COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install --jobs 20 --retry 5

COPY docker/docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["rails", "s", "-b", "0.0.0.0"]