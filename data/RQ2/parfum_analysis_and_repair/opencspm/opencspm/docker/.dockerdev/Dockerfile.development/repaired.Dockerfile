ARG RUBY_VERSION=2.7.3
FROM ruby:$RUBY_VERSION-slim-buster

ARG PG_MAJOR=13
ARG NODE_MAJOR=12
ARG BUNDLER_VERSION=2.1.4
ARG YARN_VERSION=1.22.5

# Common dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
RUN curl -f -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -f -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH=/gems \
    BUNDLE_HOME=/gems \
    GEM_HOME=/gems \
    GEM_PATH=/gems

# Install new Bundler version
RUN rm /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec && \
    gem uninstall bundler && \
    gem install bundler -v $BUNDLER_VERSION

# remove unused accounts
RUN deluser -q games && \
    deluser -q lp && \
    deluser -q news && \
    deluser -q uucp && \
    deluser -q proxy && \
    deluser -q www-data && \
    deluser -q list && \
    deluser -q irc && \
    deluser -q gnats

# Create app user
RUN groupadd -r app && \
    useradd -r -g app -d /app -s /bin/bash app

# Create directory for app code
RUN mkdir -p /data /gems /app/ui/node_modules && \
    chown -R app:app /app && \
    chown -R app:app /data && \
    chown -R app:app /gems

USER app

WORKDIR /app
