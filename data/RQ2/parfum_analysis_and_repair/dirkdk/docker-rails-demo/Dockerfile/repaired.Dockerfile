FROM ruby:3.1.0-slim
ARG precompileassets

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN curl -f -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get -y update && \
      apt-get install --fix-missing --no-install-recommends -qq -y \
        build-essential \
        vim \
        wget gnupg \
        git-all \
        curl \
        ssh \
        postgresql-client-11 libpq5 libpq-dev -y && \
      wget -qO- https://deb.nodesource.com/setup_12.x  | bash - && \
      apt-get install --no-install-recommends -y nodejs && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install -y --no-install-recommends yarn && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler -v 2.0.2
#Install gems
RUN mkdir /gems
WORKDIR /gems
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

ARG INSTALL_PATH=/opt/dockerrailsdemo
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

RUN scripts/potential_asset_precompile.sh $precompileassets
