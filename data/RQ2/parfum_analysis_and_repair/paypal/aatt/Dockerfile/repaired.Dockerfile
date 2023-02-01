FROM node:8.9.4

RUN apt-get update && apt-get install --no-install-recommends -y openssh-client git && rm -rf /var/lib/apt/lists/*
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN npm install && npm cache clean --force;
RUN git submodule init
RUN git submodule update

EXPOSE 3000
ENTRYPOINT DEBUG=AATT* http_port=3000 node app.js