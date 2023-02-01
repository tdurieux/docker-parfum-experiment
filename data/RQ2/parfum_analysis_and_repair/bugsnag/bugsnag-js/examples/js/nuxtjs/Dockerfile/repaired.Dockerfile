FROM node:10

WORKDIR /usr/src/app

COPY package* /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . /usr/src/app/
RUN npm run build
ENV HOST 0.0.0.0
CMD npm start
