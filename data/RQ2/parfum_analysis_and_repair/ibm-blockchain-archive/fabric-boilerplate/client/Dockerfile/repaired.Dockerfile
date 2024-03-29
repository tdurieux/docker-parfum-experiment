FROM node:6

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g angular-cli --loglevel error && npm cache clean --force;

# use cached layer for node modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install --loglevel error && npm cache clean --force;
RUN mv /tmp/node_modules /usr/src/app/node_modules

ADD . /usr/src/app

EXPOSE 4200
EXPOSE 49153
