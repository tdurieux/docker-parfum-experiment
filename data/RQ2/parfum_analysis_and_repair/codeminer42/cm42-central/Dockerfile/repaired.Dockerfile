FROM ruby:2.6.10

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION=14.18.3

RUN sed -i '/deb-src/d' /etc/apt/sources.list && \
  apt-get update

RUN apt-get install --no-install-recommends -y build-essential postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler
RUN curl -f -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1
RUN npm install --global --unsafe-perm yarn && npm cache clean --force;

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY .env.sample .env

RUN bundle install

WORKDIR /app
