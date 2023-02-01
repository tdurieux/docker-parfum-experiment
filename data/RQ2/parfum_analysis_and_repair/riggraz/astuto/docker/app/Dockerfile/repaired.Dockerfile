FROM ruby:2.6.6

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# Install Chrome (only needed for Capybara tests)
# Uncomment following lines if you need to run integration tests
# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN dpkg -i /google-chrome-stable_current_amd64.deb; apt-get -fy install
# RUN rm /google-chrome-stable_current_amd64.deb

ENV APP_ROOT /astuto
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

# Launch processes in Procfile
RUN gem install foreman

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ${APP_ROOT}/
RUN bundle install

# Copy package.json and install packages
COPY package.json yarn.lock ${APP_ROOT}/
RUN yarn install --check-files && yarn cache clean;

COPY . ${APP_ROOT}

# Add a script to be executed every time the container starts.
ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 3000

# No default CMD is provided in Dockerfile