FROM ruby:2.5.5
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

WORKDIR /app

# Environment
ENV RACK_ENV development
ENV RAILS_ENV development
ENV NODE_ENV development
ENV PORT 5000

ENV NODE_VERSION 10.17.0
ENV VIPS_VERSION 8.9.0
ENV BUNDLE_VERSION 2.0.1

# Install System Deps

RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        libssl-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        curl \
        git && \
    gem install bundler -v $BUNDLE_VERSION && \
    gem install foreman && rm -rf /var/lib/apt/lists/*;


# Install Node

ENV NVM_DIR /usr/local/nvm
WORKDIR $NVM_DIR

RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


# Install Vips

WORKDIR /libvips

RUN curl -f -L "https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz" \
    | tar -xzC /libvips && \
    cd vips-$VIPS_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    ldconfig && \
    cd /libvips && \
    rm -rf vips-*


# Install Yarn

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;


# Install Google Chrome

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY package.json /app/package.json
COPY yarn.lock    /app/yarn.lock
COPY .yalc        /app/.yalc

RUN yarn install && yarn cache clean;

# Move App and Precompile

COPY . /app

# Execute Order 66

EXPOSE $PORT

CMD bin/entrypoint.dev.sh foreman start --formation "$FORMATION" --env ""
