FROM node:16
MAINTAINER totaljs "info@totaljs.com"

RUN apt-get update && apt-get install -y --no-install-recommends graphicsmagick && rm -rf /var/lib/apt/lists/*

VOLUME /www
WORKDIR /www
RUN mkdir -p /www/bundles

COPY index.js .
COPY config .
COPY package.json .
COPY cms.bundle ./bundles/

RUN npm install && npm cache clean --force;
EXPOSE 8000

CMD [ "npm", "start" ]