FROM ruby:3.1.2

# set up workdir
RUN mkdir /circuitverse
WORKDIR /circuitverse

# install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y imagemagick shared-mime-info && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash \
 && apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/* \
 && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*

COPY Gemfile /circuitverse/Gemfile
COPY Gemfile.lock /circuitverse/Gemfile.lock
COPY package.json /circuitverse/package.json
COPY yarn.lock /circuitverse/yarn.lock

RUN gem install bundler
RUN bundle install  --without production
RUN yarn install && yarn cache clean;

# copy source
COPY . /circuitverse
RUN yarn build

# generate key-pair for jwt-auth
RUN openssl genrsa -out /circuitverse/config/private.pem 2048
RUN openssl rsa -in /circuitverse/config/private.pem -outform PEM -pubout -out /circuitverse/config/public.pem
