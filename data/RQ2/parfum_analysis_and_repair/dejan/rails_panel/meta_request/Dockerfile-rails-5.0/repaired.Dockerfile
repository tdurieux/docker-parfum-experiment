FROM ruby:2.6-alpine

RUN apk add --update --no-cache \
     build-base curl-dev git sqlite-dev \
     yaml-dev zlib-dev nodejs yarn tzdata

RUN mkdir /app /gem
WORKDIR /app

RUN gem install rails -v 5.0.7.2
RUN rails new .

RUN bundle remove sqlite3
RUN bundle add sqlite3 --version '~> 1.3.6'
RUN bundle install

COPY . /gem

RUN gem build /gem/meta_request.gemspec
RUN gem install /gem/meta_request-*.gem
RUN bundle add meta_request
RUN bundle install --local

COPY res/routes.rb /app/config/
COPY res/dummy_controller.rb /app/app/controllers/
COPY res/dummy /app/app/views/dummy
COPY res/meta_request_test.rb /app/test/integration/

CMD ["bin/rake"]