FROM ruby:2.7.3

RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev postgresql-client npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn n && npm cache clean --force;

# To install the specific version of Node.js
RUN n 12.16
RUN apt purge -y npm && apt autoremove -y

WORKDIR /app

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD package.json package.json
RUN yarn

ADD . /app
RUN yarn dev-build
