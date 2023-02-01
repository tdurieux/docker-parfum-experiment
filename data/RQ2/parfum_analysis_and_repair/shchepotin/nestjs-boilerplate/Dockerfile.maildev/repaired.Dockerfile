FROM node:16.15.1

RUN npm i -g maildev@1.1.0 && npm cache clean --force;

CMD maildev
