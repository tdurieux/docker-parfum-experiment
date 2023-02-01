FROM ruby:2.7.6
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler
WORKDIR /myapp
ENV BEELINE_FROM_RUBYGEMS=true
COPY Gemfile /myapp/Gemfile
RUN bundle install
COPY . /myapp
RUN bundle exec rails db:setup

EXPOSE 3000
CMD [ "bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0" ]
