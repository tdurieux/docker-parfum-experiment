FROM ruby:2.7.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN RAILS_GROUPS=assets bundle exec rake assets:precompile

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000 9395

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
