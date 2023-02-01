FROM ruby:2.7-alpine
MAINTAINER Kitsu, Inc.

RUN apk add --no-cache vips imagemagick git make gcc postgresql-client postgresql-dev build-base tzdata ffmpeg
# Install bundler
RUN gem install bundler -v '~> 2.2'

RUN mkdir -p /opt/kitsu/server
WORKDIR /opt/kitsu/server

# Preinstall gems in an earlier layer so we don't reinstall every time any file
# changes.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=2

# *NOW* we copy the codebase in
COPY . .

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80