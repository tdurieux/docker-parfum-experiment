FROM node:17

WORKDIR /src

COPY . .

RUN npm i && npm cache clean --force;

CMD npm run start:dev