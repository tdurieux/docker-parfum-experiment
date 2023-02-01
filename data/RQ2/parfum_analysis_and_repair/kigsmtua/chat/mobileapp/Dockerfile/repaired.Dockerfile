FROM node:6.10

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm install -g ionic cordova && npm cache clean --force;

RUN npm install && npm cache clean --force;

CMD ionic serve
