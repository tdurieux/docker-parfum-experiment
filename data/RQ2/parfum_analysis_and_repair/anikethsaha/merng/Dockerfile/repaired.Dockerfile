FROM node:alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
EXPOSE 5000

ENV NODE_ENV development
COPY package.json /usr/src/app

RUN npm install && npm cache clean --force;

COPY . /usr/src/app

RUN npm install -g nodemon && npm cache clean --force;

CMD ["npm","run","docker-start:dev"]

# For production the above lne will :  CMD ["npm","run","docker-start:prod"]
