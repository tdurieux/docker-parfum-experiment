FROM node:8.10

LABEL maintainer "jacob@blissfully.com"

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN yarn install --production && yarn cache clean;

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD ["yarn start"]
