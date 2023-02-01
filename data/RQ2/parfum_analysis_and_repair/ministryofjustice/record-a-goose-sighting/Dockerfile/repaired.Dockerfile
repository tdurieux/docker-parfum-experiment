FROM node:10

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /node_app

COPY package.json /node_app/
RUN npm install . && npm cache clean --force;

COPY . /node_app

CMD ["node","start.js"]