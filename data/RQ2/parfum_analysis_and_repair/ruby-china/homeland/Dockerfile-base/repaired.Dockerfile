FROM ruby:3.1.0-slim-buster

RUN gem install bundler
RUN apt update && apt install --no-install-recommends -y curl gcc g++ gnupg make && \
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y ca-certificates cron socat curl git htop tzdata imagemagick nginx libnginx-mod-http-image-filter libnginx-mod-http-geoip \
  build-essential ruby-dev openssl libpq-dev libxml2-dev libxslt-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i -g corepack && npm cache clean --force;

RUN curl -f https://get.acme.sh | sh
