FROM node:14-slim

RUN npm install -g npm@latest --loglevel=error && npm cache clean --force;
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --loglevel=error && npm cache clean --force;

COPY . .

RUN REACT_APP_API_URL=http://localhost:3001 SKIP_PREFLIGHT_CHECK=true npm run build --prefix client

RUN mv client/build build

RUN rm  -rf client/*

RUN mv build client/

EXPOSE 8080

CMD [ "npm", "start" ]