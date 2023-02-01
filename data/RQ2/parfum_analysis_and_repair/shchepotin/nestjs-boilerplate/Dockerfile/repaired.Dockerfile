FROM node:16.15.1

RUN npm i -g @nestjs/cli typescript ts-node && npm cache clean --force;

COPY package*.json /tmp/app/
RUN cd /tmp/app && npm install && npm cache clean --force;

COPY . /usr/src/app
RUN cp -a /tmp/app/node_modules /usr/src/app
COPY ./wait-for-it.sh /opt/wait-for-it.sh
COPY ./startup.dev.sh /opt/startup.dev.sh

WORKDIR /usr/src/app
RUN rm -rf .env && cp env-example .env
RUN npm run build

CMD ["/bin/bash", "/opt/startup.dev.sh"]
