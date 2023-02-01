FROM ruby:2.3.1

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils build-essential libpq-dev nodejs npm && rm -rf /var/lib/apt/lists/*;

ENV INSTALL_PATH /kanban_on_rails

ENV LANG C.UTF-8

RUN mkdir $INSTALL_PATH

WORKDIR $INSTALL_PATH

ADD Gemfile Gemfile.lock ./

RUN bundle install --binstubs

ADD package.json ./

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install && npm cache clean --force;

COPY . .
