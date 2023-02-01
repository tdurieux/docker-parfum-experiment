FROM ruby:3.0.0

RUN useradd -ms /bin/bash user

# Node pre install setup
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -

# Yarn repository
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Chrome repository
RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client nodejs yarn libnss3 libgconf-2-4 google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# Disable Chrome sandbox
RUN sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' "/opt/google/chrome/google-chrome"

ENV APP_HOME /gamou/
RUN mkdir $APP_HOME
RUN chown user $APP_HOME
USER user
WORKDIR $APP_HOME

ADD Gemfile Gemfile.lock package.json yarn.lock $APP_HOME

RUN yarn install && yarn cache clean;
RUN bundle install

CMD docker/cmd.sh
