FROM ruby:3.0-slim

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y nodejs \
  libpq-dev \
  git \
  curl \
  libjemalloc2 && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /var/www/

# We are copying the Gemfile first, so we can install
# all the dependencies without any issues
# Rails will be installed once you load it from the Gemfile
# This will also ensure that gems are cached and only updated when they change.
COPY Gemfile ./
COPY Gemfile.lock ./
COPY package.json yarn.lock .nvmrc ./

RUN NODE_ENV=development
RUN RAILS_ENV=development


# Install the gems.
RUN gem install nokogiri
RUN bundle install --jobs 20

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.16.1
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN mkdir $NVM_DIR
RUN curl -f --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;
RUN yarn cache clean
RUN yarn install --verbose && yarn cache clean;
RUN apt-get install --no-install-recommends chromium --fix-missing -y && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000
CMD ["bundle", "exec", "rails","server","-b","0.0.0.0","-p","3000"]
