FROM quay.io/democracyworks/clojure-and-node:lein-2.8.1-node-8.11.2
MAINTAINER Democracy Works, Inc. <dev@democracy.works>

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ruby \
    rubygems-integration \
    inotify-tools \
    build-essential \
    bzip2 \
    curl \
    libdbus-glib-1-2 \
    libgtk-3-0 \
    firefox-esr \
  && rm -rf /var/lib/apt/lists/* \
  && gem install sass -v 3.3.14

# install Firefox for headless testing
RUN curl -f -sSL \
  'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' \
  | tar -C /opt -xvjf -

ENV PATH="${PATH}:/opt/firefox"

# upgrade npm
RUN npm i -g npm@6.9.0 && npm cache clean --force;

# install Grunt
RUN npm install -g grunt-cli && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN npm install node-sass@3.8.0 && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY bower.json /usr/src/app/
COPY .bowerrc /usr/src/app/
RUN bower --allow-root install

COPY . /usr/src/app

RUN lein test

RUN npm prune --production

RUN lein cljsbuild once min

EXPOSE 4000 27017 28017

ENTRYPOINT [ "grunt" ]
CMD [ "default" ]
