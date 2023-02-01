FROM ruby:3.0.0
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update bundler && rm -rf /root/.gem;
RUN mkdir /rails-flog
WORKDIR /rails-flog
COPY . /rails-flog
RUN bundle install
CMD ["bundle", "exec", "rake"]
