# An Alpine image with additional Alpine packages, so native addons can
# be compiled via node-gyp.

FROM node:16.13.0-alpine3.14
WORKDIR /usr/src/app
COPY package*.json ./

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        python3 \
    && npm install --only=production \
    && apk del .build-deps && npm cache clean --force;

COPY . .
EXPOSE 3333
CMD [ "npm", "start" ]
