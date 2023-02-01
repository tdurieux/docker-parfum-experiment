FROM ruby:2.4.3-alpine

RUN apk add --no-cache \
      bash \
      build-base \
      postgresql-dev \
      postgresql

WORKDIR /tmp
COPY Gemfile* ./
RUN bundle install

WORKDIR /app
COPY . .

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["ruby", "app.rb"]
