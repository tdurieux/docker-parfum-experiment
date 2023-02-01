FROM node:7.8.0

ENV NPM_CONFIG_LOGLEVEL warn

COPY . .

RUN npm install -g serve && npm cache clean --force;

CMD serve -s

EXPOSE 5000