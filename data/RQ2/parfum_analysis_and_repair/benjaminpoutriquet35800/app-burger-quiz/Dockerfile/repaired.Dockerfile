FROM node

WORKDIR /app

ADD . /app

RUN npm install && npm cache clean --force;

ENTRYPOINT ["npm", "start"]
