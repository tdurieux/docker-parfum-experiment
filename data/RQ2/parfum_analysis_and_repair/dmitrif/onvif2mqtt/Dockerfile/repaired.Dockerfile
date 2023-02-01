FROM node:12.16.1

WORKDIR /onvif2mqtt
ADD . /onvif2mqtt

RUN npm install && npm run build && npm cache clean --force;

CMD npm start
