FROM node:latest

WORKDIR /opt

COPY package.json ./

RUN npm install && npm cache clean --force;

ENV PATH /opt/node_modules/mocha/bin:$PATH

VOLUME ["/opt/app"]

ENTRYPOINT ["npm", "test"]
