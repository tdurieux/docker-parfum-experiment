FROM node:8

RUN mkdir -p /usr/src/app \
  && apt-get update && apt-get install --no-install-recommends -y build-essential python librdkafka-dev libsasl2-dev libsasl2-modules openssl \
  && apt-get autoremove -y && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/* && rm -rf /usr/src/app

WORKDIR /usr/src/app
COPY . /usr/src/app/

RUN npm install -g node-pre-gyp && npm cache clean --force;
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
