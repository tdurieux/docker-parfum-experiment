FROM ruby:2.7.4-buster

LABEL maintainer="quepid_admin@opensourceconnections.com"

ENV home .

# Must have packages
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends vim curl tmux \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile* /srv/app/
WORKDIR /srv/app
RUN gem install bundler:1.17.3
RUN bundle install

# Dependencies for Puppeteer/Chromium
# Dependency for generating the ERD is at the end, 'graphviz'
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils libgbm1  wget graphviz \
  && rm -rf /var/lib/apt/lists/*

# may not need libgbm

# Node and Yarn
RUN wget --no-check-certificate -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update -qq && apt-get install -y --no-install-recommends nodejs yarn netcat \
  && rm -rf /var/lib/apt/lists/*

# Clean environment
RUN apt-get clean all
