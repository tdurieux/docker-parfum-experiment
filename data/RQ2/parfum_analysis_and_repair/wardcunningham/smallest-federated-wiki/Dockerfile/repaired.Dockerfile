from ooyala/quantal64-ruby1.9.3
maintainer Peter Stuifzand  "peter@stuifzand.eu"
run gem install bundler
run apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y libxml2-dev libxslt-dev build-essential git && rm -rf /var/lib/apt/lists/*;
run gem install nokogiri -v '1.5.6'
add . /wiki
expose 1111
volume /wiki/data
run cd /wiki && bundle install --without development test
cmd cd /wiki/server/sinatra && bundle exec rackup -s thin -p 1111
