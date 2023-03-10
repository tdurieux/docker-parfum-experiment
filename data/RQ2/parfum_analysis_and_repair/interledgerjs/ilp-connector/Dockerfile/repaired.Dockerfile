FROM node:8-slim

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

EXPOSE 3000

CMD [ "npm", "start" ]
