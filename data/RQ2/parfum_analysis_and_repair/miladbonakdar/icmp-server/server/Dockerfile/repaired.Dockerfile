FROM keymetrics/pm2:latest-alpine

COPY package.json .

RUN npm install --production && npm cache clean --force;

COPY pm2.json .

WORKDIR /

EXPOSE 3000 9229

COPY . .
