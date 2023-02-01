FROM node:5.6
MAINTAINER Olivier Berthonneau <olivier.berthonneau@nanocloud.com>

WORKDIR /opt
COPY ./ /opt
RUN npm install && npm cache clean --force;

CMD ["node", "./deploy.js"]
