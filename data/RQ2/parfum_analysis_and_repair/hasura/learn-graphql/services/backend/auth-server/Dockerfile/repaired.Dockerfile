FROM --platform=linux/amd64 node:8.17.0

RUN mkdir -p /opt/app

RUN chown node:node /opt/app

WORKDIR /opt/app

COPY package.json .

USER node

RUN npm install && npm cache clean --force;

COPY . .

CMD npm start
