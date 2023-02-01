FROM node:10

WORKDIR /usr/src/app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY stackdriver.js .
COPY test.txt .

ENTRYPOINT ["node","stackdriver.js"]