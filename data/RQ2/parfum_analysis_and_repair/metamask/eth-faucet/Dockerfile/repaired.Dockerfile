FROM node:14

# setup app dir
RUN mkdir -p /www/
WORKDIR /www/

# install dependencies
COPY .yarnrc yarn.lock package.json /www/
COPY patches /www/patches/
RUN yarn setup && yarn cache clean;

# copy over app dir and build
COPY config.js /www/
COPY src /www/src/
RUN yarn build && yarn cache clean;

# start server
CMD yarn start

# expose server
EXPOSE 9000
