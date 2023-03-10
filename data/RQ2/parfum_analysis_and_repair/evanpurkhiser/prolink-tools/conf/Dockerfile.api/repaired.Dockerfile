FROM node:14

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn && yarn cache clean;

COPY src /app/src/
COPY tsconfig.json /app/

ARG GIT_SHA
ENV GIT_SHA=$GIT_SHA

EXPOSE 8888
CMD ["yarn", "start-api"]
