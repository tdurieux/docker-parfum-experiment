FROM node:11
ENV NODE_ENV=prod

WORKDIR /usr/src/app

RUN npm i lerna -g --loglevel notice && npm cache clean --force;
RUN npm i yarn -g --loglevel notice && npm cache clean --force;
RUN npm i pm2 -g && npm cache clean --force;

COPY package.json .
RUN yarn install && yarn cache clean;

COPY packages/api ./packages/api
COPY packages/core ./packages/core
COPY packages/shared ./packages/shared

COPY lerna.json .
COPY tsconfig.json .
COPY tsconfig.base.json .
COPY tslint.json .

WORKDIR /usr/src/app/packages/api

WORKDIR /usr/src/app
RUN yarn bootstrap
RUN yarn build

WORKDIR /usr/src/app/packages/api

RUN cp src/.env.production dist/src/.env.production
RUN cp src/.env.ci dist/src/.env.ci
RUN cp src/.env.development dist/src/.env.development

CMD [ "pm2-runtime", "dist/src/main.js" ]
