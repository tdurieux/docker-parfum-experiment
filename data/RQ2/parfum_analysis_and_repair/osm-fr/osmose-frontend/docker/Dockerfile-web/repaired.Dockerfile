FROM node:15-alpine3.10
MAINTAINER Frédéric Rodrigo <fred.rodrigo@gmail.com>

RUN apk add --no-cache --update make gettext

RUN mkdir -p /data/project/osmose/frontend/web
WORKDIR /data/project/osmose/frontend/web

ADD ./web/package.json /data/project/osmose/frontend/web/
ADD ./web/package-lock.json /data/project/osmose/frontend/web/
ADD ./web/webpack.config.js /data/project/osmose/frontend/web/
RUN mkdir ../../node_modules && \
    ln -s ../../node_modules node_modules && \
    npm install && npm cache clean --force;

ADD ./web /data/project/osmose/frontend/web
RUN npm run build-dev

ADD ./web_api /data/project/osmose/frontend/web_api
RUN cd po && \
    make mo

ENV LANG en_US.UTF-8
CMD npm run dev-server
EXPOSE 8080
