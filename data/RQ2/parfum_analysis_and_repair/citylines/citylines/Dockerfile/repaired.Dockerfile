FROM ruby:2.6.7-slim-stretch

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y gnupg2 && \
  apt-get install --no-install-recommends curl apt-transport-https -y -qq && \
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get update -qq -y && \
  apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  && apt-get clean autoclean -y \
  && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

ENV HOME /root

WORKDIR /app

ADD Gemfile Gemfile.lock /app/

RUN \
  gem install bundler && \
  bundle install --jobs 20 --retry 5

ADD . /app/

RUN \
  yarn install --no-cache --frozen-lockfile && yarn cache clean;

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["rackup", "-p", "8080", "-o","0.0.0.0"]
