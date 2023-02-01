from ruby:2.2.2

env DEBIAN_FRONTEND noninteractive

run sed -i '/deb-src/d' /etc/apt/sources.list
run apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

workdir /tmp
copy Gemfile Gemfile
copy Gemfile.lock Gemfile.lock
copy pagseguro-oficial.gemspec pagseguro-oficial.gemspec
run mkdir -p lib/pagseguro
copy lib/pagseguro/version.rb lib/pagseguro
run bundle install

run mkdir /app
workdir /app

cmd bash
