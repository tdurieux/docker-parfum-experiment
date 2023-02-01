FROM node:16.13-slim

ARG DATABASE_URL
ARG PORT

EXPOSE ${PORT}

WORKDIR /indexer
ADD . /indexer
RUN yarn install && yarn cache clean;
RUN yarn build
CMD yarn start