FROM gliderlabs/alpine
MAINTAINER Patrick Heneise <patrick@blended.io>

RUN apk add --no-cache --update make gcc g++ python curl nodejs-npm
RUN         apk add --no-cache nodejs

# Bundle app source
ADD         . /src
RUN cd /src; npm install; npm cache clean --force; npm update

ENV         NODE_ENV production
CMD         ["/bin/sh", "/src/init.sh"]
EXPOSE      3000
