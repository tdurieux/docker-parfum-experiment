FROM node:8.2.1
RUN \
    apt-get update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install --global yarn && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/
RUN yarn install && yarn cache clean;

COPY . /usr/src/app

CMD npm start
