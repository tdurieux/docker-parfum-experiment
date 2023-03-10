FROM ruby:2.5
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    build-essential \
    libpq-dev \
    nodejs \
    graphviz \
    imagemagick && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.development.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.development.sh
ENTRYPOINT ["entrypoint.development.sh"]
EXPOSE 3000

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
