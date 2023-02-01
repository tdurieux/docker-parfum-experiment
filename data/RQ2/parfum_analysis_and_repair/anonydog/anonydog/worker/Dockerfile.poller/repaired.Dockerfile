FROM ruby:2.3.1
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN bundle install
CMD bundle exec ruby -I lib lib/anonydog/poller.rb
