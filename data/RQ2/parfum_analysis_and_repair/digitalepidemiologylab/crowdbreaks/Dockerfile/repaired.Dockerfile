FROM ruby:2.5.8

ENV BUNDLE_PATH /box/bundle_gems/
ENV NODE_PATH /box/node_modules/

# Install nodejs
RUN apt-get update
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Add Yarn repository
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Yarn
RUN apt-get update
RUN apt-get install --no-install-recommends yarn -y && rm -rf /var/lib/apt/lists/*;

# Install bundler
RUN gem install bundler -v 2.2.3

WORKDIR /app

# Install js packages
COPY package.json yarn.lock ./
RUN yarn install --check-files && yarn cache clean;

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy all other files
COPY . ./

EXPOSE 3000

CMD ["bin/rails", "s", "-p", "3000", "-b", "0.0.0.0"]

