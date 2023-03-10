FROM node:8

WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install && yarn cache clean;

CMD yarn build
