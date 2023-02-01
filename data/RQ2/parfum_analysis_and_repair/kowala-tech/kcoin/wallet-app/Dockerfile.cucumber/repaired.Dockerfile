FROM ruby:2.4.1
RUN mkdir /kowala
WORKDIR /kowala
COPY . /kowala

RUN gem install cucumber capybara selenium-webdriver rspec

RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing curl unzip && rm -rf /var/lib/apt/lists/*;
# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq --no-install-recommends install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

#Configuring the tests to run in the container
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update && rm -rf /root/.gem;
