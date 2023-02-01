FROM ruby:2.6.0

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y apt-utils build-essential apt-transport-https libxml2-dev libpq-dev postgresql-client unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https wget && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

RUN bundle config path /usr/local/bundle
ENV APP_ROOT /app

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
