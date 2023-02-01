FROM ruby:2.2.2
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs npm vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir /myapp

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /myapp
WORKDIR /myapp
