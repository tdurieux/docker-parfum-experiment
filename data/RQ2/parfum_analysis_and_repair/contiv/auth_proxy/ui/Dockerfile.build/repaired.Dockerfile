FROM node

RUN npm install -g bower && npm cache clean --force;
RUN npm install -g gulp && npm cache clean --force;

WORKDIR /contiv-ui

CMD gulp build
