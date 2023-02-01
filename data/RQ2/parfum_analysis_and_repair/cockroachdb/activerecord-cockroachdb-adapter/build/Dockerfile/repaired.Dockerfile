# This Dockerfile extends the Examples-ORM testing image in order to
# install specific dependencies required for ActiveRecord tests.

FROM cockroachdb/example-orms-builder:20200413-1918

# Native dependencies for libxml-ruby and sqlite3.
RUN apt-get --allow-releaseinfo-change update -y && apt-get install --no-install-recommends -y \
  libxslt-dev \
  libxml2-dev \
  libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

# Ruby testing dependencies.
RUN gem install bundle rake

# Add global Gem binaries to the path.
ENV PATH /usr/local/lib/ruby/gems/2.4.0::$PATH
