FROM node:16-alpine

WORKDIR /frontend

ENV PATH /frontend/node_modules/.bin:$PATH

COPY ../package.json ../yarn.lock /frontend/
RUN yarn install --network-timeout 100000 && yarn cache clean;

COPY ../ /frontend

CMD ["yarn", "start"]