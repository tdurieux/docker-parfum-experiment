FROM ruby:3.1.2

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn && rm -rf /var/lib/apt/lists/*;
RUN yarn global add gulp-cli

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN bundle install
RUN yarn install && yarn cache clean;

COPY . /app
