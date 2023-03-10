FROM node:10
ARG branch=master
RUN npm install -g browserify && npm cache clean --force;
RUN git clone https://github.com/iden3/rollup.git
WORKDIR "./rollup"
RUN git checkout $branch
RUN npm install && npm cache clean --force;
RUN npm run build:webapp
COPY config-webapp/* ./
RUN node build-config.js
RUN mv config.json ./simple-webapp/src/utils
WORKDIR "./simple-webapp"
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]