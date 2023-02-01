FROM node:8-slim

RUN apt-get update && apt-get install --no-install-recommends -y python postgresql libpq-dev build-essential libpq5 git vim && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN npm install && npm cache clean --force;
RUN cd api && npm install && npm cache clean --force;
RUN cd ledger && npm install && npm cache clean --force;
RUN cd client && npm install && npm run build && npm cache clean --force;
RUN cd webserver && npm install && npm cache clean --force;

ENV NODE_ENV production
EXPOSE 80
EXPOSE 3100
EXPOSE 3101

CMD echo "var config = { apiUrl: 'https://$API_HOSTNAME/api' }" > /usr/src/app/client/build/config.js && npm start
