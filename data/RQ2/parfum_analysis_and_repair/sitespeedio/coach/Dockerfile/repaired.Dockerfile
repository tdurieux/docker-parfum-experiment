FROM sitespeedio/webbrowsers:chrome-96.0-firefox-94.0-edge-95.0-dev

ENV DOCKER true

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.* /usr/src/app/
RUN npm install --production && npm cache clean --force;
COPY . /usr/src/app

COPY docker/scripts/start.sh /start.sh

ENTRYPOINT ["/start.sh"]
VOLUME /coach
WORKDIR /coach
