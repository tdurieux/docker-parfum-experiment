FROM node:12.16
WORKDIR /usr/app
COPY . .
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
CMD yarn start:prod