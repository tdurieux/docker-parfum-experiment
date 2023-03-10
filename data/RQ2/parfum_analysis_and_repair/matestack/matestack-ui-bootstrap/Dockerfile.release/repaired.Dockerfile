FROM ruby:3.0-alpine3.12

RUN gem install bundler:2.1.4

RUN apk update --no-cache && \
    apk add --no-cache build-base postgresql-dev git nodejs yarn tzdata bash sqlite-dev npm shared-mime-info && \
    mkdir -p /app

WORKDIR /app

COPY ./lib/ /app/lib/
COPY matestack-ui-bootstrap.gemspec /app/
COPY Gemfile* yarn* /app/
RUN bundle install

COPY package.json* /app/
RUN yarn install && yarn cache clean;

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

COPY . /app/

WORKDIR /app/spec/dummy
RUN rm package-lock.json
RUN npm install && npm cache clean --force;

WORKDIR /app

RUN touch /app/.env && set -a && source /app/.env && set +a && bundle exec rails app:webpacker:compile RAILS_ENV=production

CMD ["bundle", "exec", "rails", "server"]
