FROM ruby:3.0.2

# node lts
RUN curl -f -SL https://deb.nodesource.com/setup_14.x | bash && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update -qq && apt install --no-install-recommends -y nodejs yarn mariadb-client && rm -rf /var/lib/apt/lists/*;

# 日本語対応
ENV LANG C.UTF-8

RUN mkdir /music-server
WORKDIR /music-server
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
COPY . /music-server

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
