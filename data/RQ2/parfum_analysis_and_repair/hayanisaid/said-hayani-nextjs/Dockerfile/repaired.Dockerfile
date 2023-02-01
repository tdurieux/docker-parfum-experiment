FROM node:10.9.0-stretch

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm install && npm cache clean --force;
RUN npm build

COPY . /usr/src/app

EXPOSE 3000

CMD ["npm","start"]


