FROM resin/raspberrypi3-node:8.0.0
ENV config_dir=/config

RUN mkdir -p /usr/src/app && mkdir /config && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app
COPY .snyk /usr/src/app
RUN npm install && npm cache clean --force;

COPY default_settings.js /usr/src/app
COPY index.js /usr/src/app
CMD npm start
