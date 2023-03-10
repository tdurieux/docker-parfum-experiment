FROM ruby:2.6.5

# Add NodeJS repo
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install dependencies and remove unneeded packages/files
RUN apt-get update -qq && apt-get install -y --no-install-recommends nodejs \
                                                                     git \
                                                                     unzip \
                                                                     xvfb \
                                                                     libxi6 \
                                                                     libgconf-2-4 \
                                                                     apt-transport-https \
                                                                     yarn && rm -rf /var/lib/apt/lists/*;

# Install packages
WORKDIR /usr/src/app
COPY Gemfile* /usr/src/app/
COPY Gemfile.lock* /usr/src/app/
COPY package.json /usr/src/app/
RUN gem install bundler --no-document
RUN bundle install --without development test
RUN yarn install && yarn cache clean;

# Setup app files
COPY . /usr/src/app/
WORKDIR /usr/src/app
COPY config/database.yml.example.production config/database.yml
COPY config/secrets.yml.example config/secrets.yml

# Add entrypoint
COPY entrypoint-prod.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint-prod.sh
ENTRYPOINT ["entrypoint-prod.sh"]

# Expose rails
EXPOSE 3000

# Update and cleanup container
RUN apt-get upgrade -y && apt-get autoclean \
                       && apt-get autoremove -y \
                       && rm -rf /var/lib/apt \
                                 /var/lib/dpkg \
                                 /var/lib/cache \
                                 /var/lib/log

# App startup
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
