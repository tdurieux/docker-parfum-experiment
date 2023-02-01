FROM ruby:3

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      nodejs \
      postgresql-client && rm -rf /var/lib/apt/lists/*;

# Install Chrome
RUN wget -q -O /tmp/linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub \
  && apt-key add /tmp/linux_signing_key.pub \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install --no-install-recommends google-chrome-stable -y && rm -rf /var/lib/apt/lists/*;

# Install Chromedriver
RUN CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip \
    && chmod ugo+rx /usr/local/bin/chromedriver

RUN mkdir /project
WORKDIR /project
COPY .ruby-version Gemfile Gemfile.lock /project/

RUN gem install bundler -v $(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -1 | tr -d " ")

ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3
RUN bundle install

ENV PATH /opt/bin/:$PATH
COPY . /project
