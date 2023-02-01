FROM ruby:2.4

USER root

# Install postgres so we can restore from backups using pg_restore
RUN \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get -y --no-install-recommends install postgresql postgresql-contrib nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /web

WORKDIR /web

ENV BUNDLE_PATH=vendor/bundle
ENV BUNDLE_DISABLE_SHARED_GEMS=1

COPY Gemfile /web/Gemfile
COPY Gemfile.lock /web/Gemfile.lock
COPY vendor /web/vendor
RUN bundle install --path /web/vendor/bundle

COPY . /web

#CMD bundle exec rails s -p 3000
