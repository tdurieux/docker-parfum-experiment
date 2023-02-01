FROM mhart/alpine-node:8

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

WORKDIR /usr/src/app/scheduler
RUN npm install && npm cache clean --force;


WORKDIR /usr/src/app/seneca-job-queue
RUN npm install && npm cache clean --force;


EXPOSE 4001 4002 4003

CMD node runAll.js
