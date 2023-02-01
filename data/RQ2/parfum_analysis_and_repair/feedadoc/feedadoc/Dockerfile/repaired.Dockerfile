FROM ruby:2.7
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN mkdir /feedadoc
WORKDIR /feedadoc
COPY Gemfile /feedadoc/Gemfile
COPY Gemfile.lock /feedadoc/Gemfile.lock
RUN bundle install
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;
RUN yarn && yarn cache clean;
COPY . /feedadoc

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]