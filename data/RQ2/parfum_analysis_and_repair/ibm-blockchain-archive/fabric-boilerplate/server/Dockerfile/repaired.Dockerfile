#FROM cesarev/fabric-boilerplate
FROM node:6
RUN npm install -g grunt --loglevel error && npm cache clean --force;
RUN mkdir -p /usr/src/app/ && rm -rf /usr/src/app/

# use cached layer for node modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install --loglevel error && npm cache clean --force;
RUN mv /tmp/node_modules /usr/src/app/node_modules

ADD . /usr/src/app
WORKDIR /usr/src/app
RUN grunt build