FROM node:5.11
MAINTAINER Alexandru Rosianu <me@aluxian.com

ENV UPDATES_PORT 3000
ENV UPDATES_HOST 0.0.0.0
ENV NODE_ENV production

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app/
RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]

EXPOSE 3000
