FROM node:17.8.0-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV production

COPY package.json package-lock.json /usr/src/app/
RUN npm install --production && npm cache clean --force;

COPY . /usr/src/app

CMD npm run build
