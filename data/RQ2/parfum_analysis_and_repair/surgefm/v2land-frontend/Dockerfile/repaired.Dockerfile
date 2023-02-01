FROM node:17-alpine

WORKDIR /opt/app

ENV NODE_ENV production

COPY package*.json ./

RUN npm ci

COPY . /opt/app

RUN npm install --dev && npm run build && npm cache clean --force;

CMD [ "npm", "start" ]
