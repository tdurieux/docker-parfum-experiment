FROM node:10

WORKDIR /usr/src/app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY prometheus.js .
COPY test.txt .

EXPOSE 9464

ENTRYPOINT ["node","prometheus.js"]