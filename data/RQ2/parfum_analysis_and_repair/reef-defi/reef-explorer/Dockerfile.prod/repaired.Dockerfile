FROM node:fermium

ARG COMPONENT

RUN apt-get update && apt-get -y upgrade

RUN mkdir /app && chown -R node:node /app

WORKDIR /app

RUN wget https://raw.githubusercontent.com/eficode/wait-for/v2.2.2/wait-for -O /wait-for && chmod +x /wait-for

USER node

COPY ${COMPONENT}/package.json yarn.lock ./

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ${COMPONENT}/. ./

RUN yarn run build && yarn cache clean;

CMD [ "/wait-for", "http://graphql:8080/healthz", "-t", "0", "--", "yarn", "start" ]
