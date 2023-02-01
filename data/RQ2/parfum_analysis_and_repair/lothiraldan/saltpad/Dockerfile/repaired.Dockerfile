FROM node
MAINTAINER Boris Feld <lothiraldan@gmail.com>

# Prepare app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app


COPY package.json .
RUN npm install && npm cache clean --force;
COPY bower.json .
RUN ./node_modules/bower/bin/bower install --allow-root

COPY . /usr/src/app

VOLUME /usr/src/app

EXPOSE 3333
CMD npm start
