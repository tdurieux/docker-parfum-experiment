FROM node:lts

WORKDIR /app

RUN npm install -g n && npm cache clean --force;
COPY package.json .
RUN n auto
COPY semantic.json .
RUN npm install && npm cache clean --force;

COPY src ./src
COPY webpack ./webpack

CMD npm run build
