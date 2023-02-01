FROM node:15-alpine
LABEL name "djs-utils"
LABEL version "0.3.0"
LABEL maintainer "almostSouji <https://github.com/almostSouji>"
ENV FORCE_COLOR=1
WORKDIR /usr/djs-utils
COPY package.json ./
RUN apk add --no-cache --update \
&& apk add --no-cache ca-certificates \
&& apk add --no-cache --virtual .build-deps git curl build-base python g++ make \
&& npm i \
&& apk del .build-deps && npm cache clean --force;
COPY . .
RUN npm run build
CMD ["node", "dist/src/index.js"]