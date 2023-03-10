FROM node:0.10
MAINTAINER Federico Gonzalez <https://github.com/fedeg>

RUN npm config set registry http://registry.npmjs.org
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g foreman && npm cache clean --force
ADD package.json /usr/src/app/
RUN npm install && npm cache clean --force
ADD . /usr/src/app

CMD [ "nf", "start" ]
