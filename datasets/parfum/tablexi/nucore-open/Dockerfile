FROM ruby:2.6.6 as base

WORKDIR /app
ENV BUNDLE_PATH /gems

# Install NodeJS based on https://github.com/nodesource/distributions#installation-instructions
RUN apt-get update && \
 # Installs the node repository
 curl -sL https://deb.nodesource.com/setup_16.x | bash && \
 # Installs the node repository
 apt-get install --yes nodejs && \
 npm install --global yarn && \
 apt-get autoremove -y

# Copy just what we need in order to bundle
COPY Gemfile Gemfile.lock .ruby-version /app/
# We reference the engines in the Gemfile, so we need them to be there, too
COPY vendor/engines /app/vendor/engines

# Install Bundler 2
RUN gem install bundler --version=$(cat Gemfile.lock | tail -1 | tr -d " ")

# Build bundle
RUN bundle install

# Copy application code base into image
COPY . /app

RUN cp config/database.yml.mysql.template config/database.yml && \
  cp config/secrets.yml.template config/secrets.yml

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-p", "3000"]

FROM base as develop

ENTRYPOINT ["./docker-entrypoint.sh"]

FROM base as deploy

ENV RAILS_ENV production
RUN bundle install --without=development test
RUN yarn install
# asset compile
RUN SECRET_KEY_BASE=fake bundle exec rake assets:precompile
