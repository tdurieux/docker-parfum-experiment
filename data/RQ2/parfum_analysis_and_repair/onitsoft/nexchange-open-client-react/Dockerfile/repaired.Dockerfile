FROM node:10

RUN npm install -g yarn && npm cache clean --force;

WORKDIR /deploy/app/
COPY . .

RUN yarn install && yarn cache clean;
RUN yarn test:ci -u --ci --all && yarn cache clean;
RUN yarn build && yarn cache clean;
VOLUME [ "/deploy/app/build" ]
