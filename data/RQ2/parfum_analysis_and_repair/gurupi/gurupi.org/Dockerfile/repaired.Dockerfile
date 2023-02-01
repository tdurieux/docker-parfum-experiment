from ruby:1.9.3

env DEBIAN_FRONTEND noninteractive

run sed -i '/deb-src/d' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y build-essential postgresql-client nodejs && rm -rf /var/lib/apt/lists/*;

run gem install --no-ri --no-rdoc bundler foreman

workdir /tmp
copy Gemfile Gemfile
copy Gemfile.lock Gemfile.lock

run bundle install

workdir /app
