FROM ruby:3.1.0

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  build-essential \
  libpq-dev && \
  curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install --no-install-recommends -y nodejs yarn default-libmysqlclient-dev libvips && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace