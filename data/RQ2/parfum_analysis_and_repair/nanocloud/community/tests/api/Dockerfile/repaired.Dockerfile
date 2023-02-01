FROM node:5.6
MAINTAINER Olivier Berthonneau <olivier.berthonneau@nanocloud.com>

WORKDIR /opt
RUN npm install -g mocha && npm cache clean --force;
COPY ./ /opt
RUN rm -rf ./node_modules && npm install && npm cache clean --force;

CMD ["mocha", "index.js"]
