FROM circleci/node:latest-browsers

WORKDIR /usr/src/app/
USER root
COPY package.json ./
RUN yarn && yarn cache clean;

COPY ./ ./

RUN yarn run build:prod && yarn cache clean;

RUN ls app/public/local

EXPOSE 7001

CMD ["yarn", "run", "start"]