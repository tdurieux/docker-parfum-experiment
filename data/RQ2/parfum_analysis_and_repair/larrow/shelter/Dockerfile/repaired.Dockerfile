FROM ruby:2.3

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential libpq-dev nodejs less && \
  mkdir -p /usr/src/app && rm -rf /usr/src/app && rm -rf /var/lib/apt/lists/*;

COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app
RUN bundle exec rake assets:precompile

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES 1
ENV REDIS_URL "redis://redis/0"
ENV RAILS_LOG_TO_STDOUT true

RUN mv docker-entrypoint.rb /entrypoint.rb && \
    mv prepare.sh /prepare.sh

ENTRYPOINT ["/entrypoint.rb"]

