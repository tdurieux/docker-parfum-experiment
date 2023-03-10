FROM node:6.6.0

COPY . /starter
COPY package.json /starter/package.json
COPY .env.example /starter/.env.example

WORKDIR /starter

RUN npm install && npm cache clean --force;

CMD ["npm","start"]

EXPOSE 8888