FROM ruby:2.6

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  nodejs \
  postgresql-client \
  xvfb && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
