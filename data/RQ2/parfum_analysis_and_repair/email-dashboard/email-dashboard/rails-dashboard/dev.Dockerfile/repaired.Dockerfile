FROM ruby:2.4.2

LABEL maintainer="Sadik Ay <sadikay2@gmail.com>"

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libevent-dev && rm -rf /var/lib/apt/lists/*;

# Yarn requirements
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install --no-install-recommends -qq -y build-essential libpq-dev nodejs yarn && rm -rf /var/lib/apt/lists/*;

# Mysql requirements
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /build && mkdir /dashboard

COPY Gemfile /var/app/Gemfile
COPY Gemfile.lock /var/app/Gemfile.lock
COPY package.json /var/app/package.json

WORKDIR /var/app

RUN bundle install
RUN yarn install && yarn cache clean;

COPY . /var/app

ENV RAILS_ENV development
ENV RACK_ENV development
CMD  rake db:migrate
