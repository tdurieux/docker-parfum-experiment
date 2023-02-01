FROM node:4.2.2

RUN mkdir -p /usr/workdir
WORKDIR /usr/workdir

COPY files /usr/workdir

RUN npm install && npm cache clean --force;

ENTRYPOINT ["npm", "run"]
