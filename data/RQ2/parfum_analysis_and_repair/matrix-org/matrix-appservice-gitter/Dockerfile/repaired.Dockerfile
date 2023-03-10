FROM node:current-alpine

VOLUME /data/ /config/

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN apk add --no-cache git && npm install --only=production && npm cache clean --force;

EXPOSE 5858

CMD [ "node", "--max-old-space-size=2048", "index.js", "-c", "/config/config.yaml", "-p", "5858", "-f", "/config/gitter-registration.yaml" ]
