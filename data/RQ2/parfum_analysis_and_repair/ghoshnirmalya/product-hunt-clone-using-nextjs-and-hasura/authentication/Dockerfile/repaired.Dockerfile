FROM mhart/alpine-node:11.1.0

RUN mkdir /authentication-app

WORKDIR /authentication-app

RUN apk upgrade --update-cache --available && apk add openssl && apk add --no-cache bash git && rm -rf /var/cache/apk/*

ENV PATH /authentication-app/node_modules/.bin:$PATH

COPY . /authentication-app

RUN yarn install && yarn cache clean;

CMD ["yarn", "start"]
