FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

COPY Gemfile Gemfile.lock /tmp/
RUN gem install bundler && bundle install --jobs 20 --retry 5

ADD . /app
WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
