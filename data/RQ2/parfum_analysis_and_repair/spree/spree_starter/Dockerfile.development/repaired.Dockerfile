FROM ruby:3.0.3

RUN apt-get update -yq \
  && apt-get upgrade -yq \
  #ESSENTIALS
  && apt-get install -y -qq --no-install-recommends build-essential curl git-core vim passwd unzip cron gcc wget netcat \
  # RAILS PACKAGES NEEDED
  && apt-get update \
  && apt-get install -y --no-install-recommends imagemagick postgresql-client \
  # INSTALL NODE \
  && curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  # INSTALL YARN
  && npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Clean cache and temp files, fix permissions
RUN apt-get clean -qy \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock
RUN yarn install && yarn cache clean;

# install specific version of bundler
RUN gem install bundler -v 2.2.32

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle \
  BUNDLE_BIN=/bundle/bin \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 4000

CMD ["bash"]
