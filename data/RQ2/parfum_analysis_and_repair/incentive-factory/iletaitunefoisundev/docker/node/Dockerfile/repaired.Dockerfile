FROM node:lts-alpine

WORKDIR /var/www/client
COPY client/package*.json /var/www/client/

RUN npm install -g npm@latest && npm cache clean --force;
RUN npm uninstall -g @angular/cli
RUN npm cache clean --force
RUN npm install -g @angular/cli@latest && npm cache clean --force;
RUN npm ci

RUN apk add --no-cache chromium
RUN apk add --no-cache chromium-chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser

EXPOSE 4200
CMD ["ng", "serve", "--host", "0.0.0.0"]