FROM node:16.5.0

RUN mkdir --parents /usr/src/cache && rm -rf /usr/src/cache
WORKDIR /usr/src/cache
COPY ./package*.json ./
RUN npm install && npm cache clean --force;

RUN mkdir --parents /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

CMD /usr/src/app/entrypoint.sh
