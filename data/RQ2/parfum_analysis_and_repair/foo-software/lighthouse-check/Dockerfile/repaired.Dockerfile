# Inspired by:
# https://github.com/alpeware/chrome-headless-stable/blob/master/Dockerfile
FROM ubuntu:18.04

LABEL maintainer "Foo <hello@foo.software>"

# install node
RUN apt-get update \
  && apt-get -y --no-install-recommends install curl gnupg build-essential \
  && curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN node -v
RUN npm -v

# install chrome
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install libnss3 libnss3-tools libfontconfig1 wget ca-certificates apt-transport-https inotify-tools \
  gnupg \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN google-chrome-stable --version

RUN npm install @foo-software/lighthouse-check@6 -g && npm cache clean --force;

CMD ["lighthouse-check"]
