FROM node:8
WORKDIR /usr/src/app

COPY . .

RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run build

CMD node dist/index.js
