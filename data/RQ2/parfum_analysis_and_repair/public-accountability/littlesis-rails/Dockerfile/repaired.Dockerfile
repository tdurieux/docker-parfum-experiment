FROM ruby:3.1.2-bullseye
LABEL maintainer="dev@littlesis.org"

RUN apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install \
    brotli \
    build-essential \
    coreutils \
    cron \
    csvkit \
    curl \
    git \
    gnupg \
    grep \
    gzip \
    imagemagick \
    libasound2 \
    libdbus-glib-1-dev \
    libgtk-3-0 \
    libmagickwand-dev \
    libsqlite3-dev \
    libx11-xcb1 \
    lsof \
    redis-tools \
    sqlite3 \
    unzip \
    zip && rm -rf /var/lib/apt/lists/*;

# Postgres
RUN curl -f "https://www.postgresql.org/media/keys/ACCC4CF8.asc" > /usr/share/keyrings/ACCC4CF8.asc
RUN echo "deb [signed-by=/usr/share/keyrings/ACCC4CF8.asc] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client-13 libpq-dev && rm -rf /var/lib/apt/lists/*;

# Manticore
RUN curl -f -sSL https://repo.manticoresearch.com/repository/manticoresearch_bullseye/dists/bullseye/main/binary-amd64/manticore_4.2.0-211223-15e927b28_amd64.deb > /tmp/manticore.deb
RUN echo '4ccad08485d404ce0ae2bf7e7257e77d2b28d7b7fb3578201c5d734d85ec8e64  /tmp/manticore.deb' | sha256sum -c -
RUN apt-get install --no-install-recommends -y /tmp/manticore.deb && rm -rf /var/lib/apt/lists/*;

# Node
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm && npm cache clean --force;

# Firefox and Geckodriver
RUN curl -f -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | tar xjf - -C /opt
RUN printf "#!/bin/sh\nexec /opt/firefox/firefox \$@\n" > /usr/local/bin/firefox && chmod +x /usr/local/bin/firefox && firefox -version
RUN curl -f -L "https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz" | tar xzf - -C /usr/local/bin

# Setup gem & bundler
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

RUN mkdir -p /littlesis # && chown littlesis:littlesis /littlesis
WORKDIR /littlesis

COPY ./Gemfile.lock ./Gemfile ./
RUN bundle install --jobs=2

COPY ./package.json ./package-lock.json ./
# Fixes issue when installing sharp
RUN npm config set unsafe-perm true
RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD ["bundle", "exec", "puma"]
