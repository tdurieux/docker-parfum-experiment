FROM node:lts AS dist
COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . ./

RUN yarn build:prod && yarn cache clean;

FROM node:lts AS node_modules
COPY package.json yarn.lock ./

RUN yarn install --prod && yarn cache clean;

FROM node:lts

ARG PORT=3000

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY --from=dist dist /usr/src/app/dist
COPY --from=node_modules node_modules /usr/src/app/node_modules

COPY . /usr/src/app

EXPOSE $PORT

CMD [ "yarn", "start:prod" ]
