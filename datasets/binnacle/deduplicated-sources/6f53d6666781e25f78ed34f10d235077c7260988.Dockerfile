# Image to do fonctionnal Selenium tests locally, with Chrome and Firefox
# Author: Caliopen
# Date: 2018-08-03

FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl wget unzip software-properties-common

# node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install chromedriver
RUN wget -N http://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip -P ~/ && \
unzip ~/chromedriver_linux64.zip -d ~/ && \
rm ~/chromedriver_linux64.zip && \
mv -f ~/chromedriver /usr/local/bin/chromedriver && \
chmod 0755 /usr/local/bin/chromedriver

# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.21.0/geckodriver-v0.21.0-linux64.tar.gz && \
tar -xvzf geckodriver* && \
rm geckodriver-v0.21.0-linux64.tar.gz && \
chmod +x geckodriver && \
mv geckodriver /usr/local/bin/

# Install chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add &&\
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# We need firefox 62 https://bugzilla.mozilla.org/show_bug.cgi?id=1447977
# After the firefox beta releases we can drop this line
RUN add-apt-repository ppa:mozillateam/firefox-next

RUN apt-get update && apt-get install -y make g++ nodejs yarn default-jdk google-chrome-stable firefox

ENTRYPOINT ["node"]
