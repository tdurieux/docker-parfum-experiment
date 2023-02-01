FROM ruby:2.7.2

RUN apt-get update && apt-get install --no-install-recommends -y curl wget gnupg git build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn && \
    apt-get update && \
    apt-get install --no-install-recommends -y curl graphviz nodejs && \
    bundle config --global frozen 1 && \
    mkdir -p /app && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle install && \
    yarn install && yarn cache clean;

RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD bundle exec passenger start -p $PORT --max-pool-size 3
