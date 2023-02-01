FROM ruby:2.5
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs bundler && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
RUN rake app:update:bin
CMD ["/myapp/start"]
