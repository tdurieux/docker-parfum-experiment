FROM node:16

COPY package*.json /usr/src/app/
WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;

COPY . /usr/src/app
ENV DEPLOY_SUBGRAPH=true
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]