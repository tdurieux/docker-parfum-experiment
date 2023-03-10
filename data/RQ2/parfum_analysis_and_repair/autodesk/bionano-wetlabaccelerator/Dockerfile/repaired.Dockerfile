#Docker file for local building and serving only
FROM ubuntu:14.04
MAINTAINER Maxwell Bates <maxwell.bates@autodesk.com>

RUN apt-get update
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

#Node.js https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g grunt-cli && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN npm install -g forever && npm cache clean --force;
RUN npm install -g nodemon@dev && npm cache clean --force;

ENV APP /app

COPY package.json /app/package.json
COPY app/scripts/omniprotocol /app/app/scripts/omniprotocol
RUN cd /app ; npm install && npm cache clean --force;

COPY bower.json /app/bower.json
RUN cd /app ; bower install --allow-root

COPY app /app/app
COPY files /app/files
COPY .travis.yml /app/.travis.yml
COPY Gruntfile.js /app/Gruntfile.js

COPY server /app/server
COPY CHECKS /app/CHECKS

WORKDIR /app

CMD npm run start
