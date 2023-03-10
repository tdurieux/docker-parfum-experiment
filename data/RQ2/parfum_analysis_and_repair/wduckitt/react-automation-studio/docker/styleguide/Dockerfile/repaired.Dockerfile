FROM node:14.15.3

ADD ./ReactApp/package.json /app/package.json

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH


RUN npm install && npm cache clean --force;
ADD ./ReactApp/public /app/public

ADD  ./.env /app/
ADD ./ReactApp/src /app/src
ADD ./ReactApp/styleguide.config.js /app/styleguide.config.js
COPY ./ReactApp/img /app/img
RUN npm run styleguidebuild
ADD ./ReactApp/img /app/styleguide/img
VOLUME /build
CMD cp -R /app/styleguide/* /build
