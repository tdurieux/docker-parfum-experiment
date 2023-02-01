FROM ruby:2.5.8

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev postgresql-client nodejs poppler-utils advancecomp gifsicle jhead jpegoptim libjpeg-progs optipng pngcrush pngquant && rm -rf /var/lib/apt/lists/*;

# enable utf8 in irb
ENV LANG C.UTF-8

RUN gem install bundler --version 2.1.4

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

EXPOSE 5000
