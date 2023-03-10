FROM ruby:2.6.5

# Add NodeJS repo
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install dependencies and remove unneeded packages/files
RUN apt-get update -qq && apt-get install -y --no-install-recommends cron \
                                               nodejs \
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
RUN gem install bundler --no-document
RUN bundle install --without development test

# Setup app files
COPY . /usr/src/app/
WORKDIR /usr/src/app
COPY config/database.yml.example.production config/database.yml

# Create log file and link to stdout
RUN touch /var/log/cron.log

# Add entrypoint
COPY entrypoint-cron.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint-cron.sh
ENTRYPOINT ["entrypoint-cron.sh"]

# Update and cleanup container
RUN apt-get upgrade -y && apt-get autoclean \
                       && apt-get autoremove -y \
                       && rm -rf /var/lib/apt \
                                 /var/lib/dpkg \
                                 /var/lib/cache \
                                 /var/lib/log

# App startup
CMD ["cron", "-f"]
