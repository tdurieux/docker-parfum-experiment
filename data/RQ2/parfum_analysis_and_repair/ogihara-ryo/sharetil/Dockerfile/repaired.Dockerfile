FROM ruby:2.7.0

ENV LANG C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /app

# nodejs, yarn, postgresql-clientをインストール
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -y nodejs yarn postgresql-client && rm -rf /var/lib/apt/lists/*;

# chromedriverの依存ライブラリをインストール
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -y google-chrome-stable libnss3 libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

# chromedriverをインストール
RUN CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean;

# rails serverはdocker-compose.ymlで起動する
