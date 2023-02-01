FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /web
COPY . /web
WORKDIR /web
RUN bundle install
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
