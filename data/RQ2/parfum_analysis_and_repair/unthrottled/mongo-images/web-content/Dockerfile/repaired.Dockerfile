FROM node:9.2.0
MAINTAINER Alex Simons "alexsimons9999@gmail.com"
USER root

WORKDIR /app

ADD ./package.json .

RUN npm install && npm cache clean --force;

ADD . .

ENTRYPOINT ["npm", "run", "watch"]

