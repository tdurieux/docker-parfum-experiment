FROM node:8.14.0

ENV HOME "/home/xpub"

RUN mkdir -p ${HOME}

WORKDIR ${HOME}

# install Chrome
RUN curl -f -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y google-chrome-stable socat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.json yarn.lock ./
COPY client client
COPY packages packages

# We do a development install because react-styleguidist is a dev dependency and we want to run tests
# Remove cache and offline mirror in the same command, to avoid creating intermediate layers
RUN yarn install --frozen-lockfile \
    && yarn cache clean \
    && rm -rf /npm-packages-offline-cache

COPY \
    app.js \
    newrelic.js \
    .babelrc \
    .eslintignore \
    .eslintrc.js \
    .prettierrc \
    .stylelintignore \
    .stylelintrc \
    styleguide.config.js \
    ./

# Yes! we do need all this and the reason is that the browser tests use the config
# in turn the config relies on packages.
# TODO: Fix the browser tests by passing in the "URL under test" as an env var

COPY app app
COPY config config
COPY scripts scripts
COPY styleguide styleguide
COPY test test
COPY webpack webpack
COPY templates templates

CMD []
