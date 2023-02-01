FROM ruby:2.4.6
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
