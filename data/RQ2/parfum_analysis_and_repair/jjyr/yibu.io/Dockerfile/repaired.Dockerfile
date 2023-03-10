FROM rails:5

RUN apt-get update
RUN apt-get install --no-install-recommends -y locales locales-all && rm -rf /var/lib/apt/lists/*;
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# update bundler version
RUN gem install bundler

# install gems
WORKDIR /app
ADD Gemfile /app
ADD Gemfile.lock /app
RUN bundle install

# install nodejs
RUN apt-get install --no-install-recommends -y apt-transport-https && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install yarn
RUN npm install -g yarn && npm cache clean --force;
ENV PATH="${PATH}:`npm bin`"
RUN ln -s `which nodejs` /usr/local/bin/node

# install yarn packages
ADD bin /app/bin
ADD package.json /app
ADD yarn.lock /app
RUN bin/yarn

# add app directory
ADD . /app

ENV RAILS_ENV production

RUN bin/rake assets:precompile

# puma config
ENV RAILS_MAX_THREADS 5
ENV WEB_CONCURRENCY 1
