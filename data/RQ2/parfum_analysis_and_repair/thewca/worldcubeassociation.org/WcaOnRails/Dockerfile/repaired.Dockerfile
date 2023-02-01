FROM ruby:3.1.2
EXPOSE 3000

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;

# Install Node 16 LTS
# From: https://github.com/nodesource/distributions
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Add PPA needed to install yarn.
# From: https://yarnpkg.com/en/docs/install#debian-stable
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  yarn \
  build-essential \
  nodejs \
  mariadb-client \
  libssl-dev \
  tzdata && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && gem install bundler && rm -rf /root/.gem;
