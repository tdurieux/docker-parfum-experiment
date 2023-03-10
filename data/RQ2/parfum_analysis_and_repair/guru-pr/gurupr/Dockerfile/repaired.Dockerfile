FROM ruby:2.5.3

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
