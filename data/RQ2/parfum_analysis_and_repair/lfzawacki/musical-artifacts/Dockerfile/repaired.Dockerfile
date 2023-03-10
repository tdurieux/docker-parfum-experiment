FROM ruby:2.5
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client git-core zlib1g-dev build-essential libreadline-dev libssl-dev curl redis-server awesfx && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
