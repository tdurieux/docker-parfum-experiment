FROM node:0.8.28
MAINTAINER Outsider <outsideris@gmail.com>

COPY ./src/ /src
RUN cd /src; npm install && npm cache clean --force;

EXPOSE  8001

CMD ["node", "/src/socketio-slide.js"]
