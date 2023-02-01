FROM ubuntu:20.04

LABEL version="0.2"

### See also doc/user.md and BROWSER_COMPATIBILITY in browser/js/model.js
LABEL description="An Cypress based docker image which comes with cypress pipeline and various browsers version.\
Versions: \
    Firefox: 62 (legacy), 78 (supported), 89 (latest) \
    Chromium: 75 (legacy), 79 (supported), 93 (latest)"

WORKDIR /app
COPY  cypress.json .
COPY  package.json .
COPY  cypress_script.bash script.bash

##################################
### Update and install ressources
##################################
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Paris"
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y -q npm libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb wget bzip2 tar unzip nano curl ca-certificates make python python3 python2.7 &&\
 apt-get -y -q autoremove &&\
 wget -qO- https://deb.nodesource.com/setup_14.x | bash - && \
 apt install --no-install-recommends -y nodejs && \
 mkdir -p /etc/ssl/certs/ /app/browsers && rm -rf /var/lib/apt/lists/*;


######################
### download browsers
######################
# https://chromium.cypress.io/; allow to get old versions of chromium
RUN curl -f -Lo firefox_latest.tar.bz2 'https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US' && \
 tar -xjf firefox_latest.tar.bz2 && \
 mv firefox browsers/firefox_latest && \
 wget -q https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/886661/chrome-linux.zip -O chrome-latest.zip && \
 unzip -q chrome-latest.zip && \
 mv  chrome-linux browsers/chrome_latest && \

 wget -q https://ftp.mozilla.org pu /firefox/releases/62.0/linux-x86_6 /f \
 tar -xjf firefox-legacy.tar.bz2 && mv firefox browsers/firefox_legacy &&\
 wget -q http://commondatas or \
 unzip -q chrome-legacy.zip &&\
 mv  chrome-linux browsers/chrome_legacy &&\

 wget -q https://ftp.mozilla.org/pub/firefox/releases/78.0/linux-x86_64/fr/firefox-78.0.tar.bz2 -O firefox-supported.tar.bz2 &&\
 tar -xjf firefox-supported.ta .b \
 wget -q http://commondatastorage.googleapi .c \
 unzip -q chrome-supported.zip &&\ && rm firefox_latest.tar.bz2


RUN npm i cypress && $(npm bin)/cypress verify && npm cache clean --force;
