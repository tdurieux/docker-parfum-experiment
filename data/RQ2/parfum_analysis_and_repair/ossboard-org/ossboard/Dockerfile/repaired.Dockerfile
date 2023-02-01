FROM ruby:2.5.0

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes postgresql postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

RUN bundle config --global frozen 1

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test -j 5
ADD . /app

ENV LANG=en_US.UTF-8
ENV HANAMI_HOST=0.0.0.0
ENV HANAMI_ENV=development

EXPOSE 2300

CMD hanami db migrate && hanami server
