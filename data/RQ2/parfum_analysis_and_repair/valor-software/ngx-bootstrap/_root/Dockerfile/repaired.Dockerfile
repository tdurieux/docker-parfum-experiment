FROM node

RUN apt-get update

RUN mkdir /home/ngx-bootstrap

WORKDIR  /home/ngx-bootstrap

COPY .. ./

RUN npm i && npm cache clean --force;

RUN npm run build

RUN npm run link

RUN npm run build:dynamic

EXPOSE 3000

CMD ["node", "demo/dist/server.js"]

