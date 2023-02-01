FROM node:9.3.0

ENV HOME /r2
WORKDIR $HOME

COPY package.json package-lock.json $HOME/
RUN npm install && npm cache clean --force;

COPY . $HOME
CMD npm start
