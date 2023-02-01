FROM node:boron

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

ENV NODE_ENV production
EXPOSE 3000

CMD [ "npm", "start" ]
