FROM node:12

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm install -g /usr/src/app && npm cache clean --force;

CMD ["nginx-linter"]
