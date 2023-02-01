FROM ruby:3.1.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /myapp/rdv-solidarites.fr

ENV NODE_VERSION=16.13.0
ENV BUNDLE_PATH=vendor/bundle
ENV BUNDLE_BIN=vendor/bundle/bin
ENV BUNDLE_DEPLOYMENT=1

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN npm version && npm install --global yarn && npm cache clean --force;

COPY . .

RUN gem install bundler --conservative

RUN gem install foreman --conservative

RUN bundle install -j4

RUN yarn install && yarn cache clean;

RUN yarn run build

ENTRYPOINT ["/bin/bash", "./bin/start_web_server"]

EXPOSE 3000


