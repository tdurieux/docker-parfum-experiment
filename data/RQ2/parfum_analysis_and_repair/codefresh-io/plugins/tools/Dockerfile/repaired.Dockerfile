FROM node:alpine
WORKDIR /src
COPY ./package.json /src
RUN npm install && npm cache clean --force;
COPY . /src

CMD  ["node", "/src/index.js"]