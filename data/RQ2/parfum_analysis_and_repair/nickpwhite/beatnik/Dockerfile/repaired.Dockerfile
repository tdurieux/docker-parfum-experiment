FROM ruby:2.7.6

ENV DEBIAN_FRONTEND noninteractive

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt update && apt install --no-install-recommends -y firefox-esr xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends nodejs yarn && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
RUN curl -f -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | tar -jx
RUN ln -s /opt/firefox/firefox /bin/firefox

COPY Gemfile Gemfile.lock /tmp/
WORKDIR /tmp
RUN bundle install

COPY package.json yarn.lock /tmp/
RUN yarn install && yarn cache clean;

WORKDIR /beatnik
RUN ln -s /tmp/node_modules

COPY . /beatnik
RUN bin/webpack
RUN bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
