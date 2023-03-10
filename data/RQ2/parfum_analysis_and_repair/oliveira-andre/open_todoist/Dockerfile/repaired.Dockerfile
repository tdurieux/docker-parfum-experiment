FROM ruby:2.7.1

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  nodejs yarn build-essential libpq-dev imagemagick git-all vim && rm -rf /var/lib/apt/lists/*;


ENV BUNDLE_PATH /gems
RUN mkdir $BUNDLE_PATH

COPY Gemfile .
RUN bundle install

ENV INSTALL_PATH /var/www/open_todoist
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .

RUN yarn install && yarn cache clean;

ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 3334
