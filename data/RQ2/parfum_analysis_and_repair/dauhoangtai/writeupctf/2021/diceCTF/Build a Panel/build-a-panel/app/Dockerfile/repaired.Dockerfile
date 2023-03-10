FROM node:12

RUN mkdir -p /home/ctf/app
RUN mkdir /home/ctf/app/db

WORKDIR /home/ctf/app

COPY ./package.json ./

RUN npm install && npm cache clean --force;

COPY ./ ./

CMD ["node", "server.js"]