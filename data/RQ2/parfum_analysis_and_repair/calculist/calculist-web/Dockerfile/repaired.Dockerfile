FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /calculist-web
WORKDIR /calculist-web
COPY Gemfile /calculist-web/Gemfile
COPY Gemfile.lock /calculist-web/Gemfile.lock
RUN gem install bundler -v 1.16.5
RUN bundle install
COPY . /calculist-web
