FROM node:8.1.2-slim
MAINTAINER Mac Gainor <mac.gainor@gmail.com>

# install the node modules at container build time
ADD package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN mkdir -p /react && cp -a /tmp/node_modules /react

# add project code
ADD . /react
WORKDIR /react

EXPOSE 2100
ENTRYPOINT ["/react/entrypoints/build.sh"]

