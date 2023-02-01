FROM node:4.5
RUN npm i -g npm@3 && npm cache clean --force;
EXPOSE 3000
ENV DIR /usr/src/app
RUN mkdir -p $DIR
WORKDIR $DIR
COPY . $DIR
RUN npm install && npm cache clean --force;
RUN $DIR/node_modules/.bin/gulp build
CMD node server

