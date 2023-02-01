FROM node:7

MAINTAINER akinoniku

RUN npm i -g yarn

ADD ./package.json /tmp/package.json
ADD ./yarn.lock /tmp/yarn.lock
RUN cd /tmp && npm i
#RUN cd /tmp && yarn

# start compile
COPY . /build

RUN rm -rf /build/node_modules \
&& mv /tmp/node_modules /build/node_modules \
&& cd /build \
&& mv .babelrc.bak .babelrc \
&& npm run build \
&& rm -rf /build/dist/*.map \
&& mv /build/dist/* /srv/ \
&& mv /build/serve_files/* /srv/

ADD ./src/favicon.ico /build/dist/favicon.ico

