FROM ruby:2.7.2

ENV INSTALL_PATH /app

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install --no-install-recommends -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev \
    libcurl4-openssl-dev libffi-dev yarn vim nano && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install
RUN yarn install --check-files && yarn cache clean;

COPY . $INSTALL_PATH
