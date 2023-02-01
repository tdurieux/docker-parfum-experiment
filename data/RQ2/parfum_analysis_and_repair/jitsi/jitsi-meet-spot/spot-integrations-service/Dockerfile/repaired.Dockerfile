FROM node:12.13-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . .

RUN npm install --only=prod && npm cache clean --force;

EXPOSE 3789 2112

CMD [ "npm", "start" ]
