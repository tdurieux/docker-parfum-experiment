FROM node:10-buster

WORKDIR /opt/eventlogging
COPY . ./
RUN npm install && npm cache clean --force;

EXPOSE 8192
CMD [ "npm", "run", "eventgate-devserver" ]
