FROM node:4.0

WORKDIR /src

RUN npm install -g ember-cli && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN npm install -g phantomjs && npm cache clean --force;

ADD package.json /src/package.json
ADD bower.json /src/bower.json

RUN npm install && npm cache clean --force;
RUN bower --allow-root install

EXPOSE 4200
