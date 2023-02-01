FROM node:4.5

ADD . /proxy
RUN cd /proxy; npm install --production && npm cache clean --force;
EXPOSE 8080

