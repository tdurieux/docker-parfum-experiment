#
# This image is intended to be used to test and demo Solidus
# it is not intended for production purposes
#
FROM ruby:2.5.1

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /solidus

WORKDIR /solidus

ADD . /solidus

RUN bundle install

RUN bundle exec rake sandbox

CMD ["sh", "./lib/demo/docker-entrypoint.sh"]