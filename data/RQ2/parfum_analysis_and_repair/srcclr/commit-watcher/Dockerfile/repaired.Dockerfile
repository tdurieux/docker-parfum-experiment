FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs nodejs-legacy npm mysql-client vim cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler && bundle install && bundle update

RUN mkdir /myapp
ADD . /myapp
WORKDIR /myapp

ENTRYPOINT scripts/deploy
