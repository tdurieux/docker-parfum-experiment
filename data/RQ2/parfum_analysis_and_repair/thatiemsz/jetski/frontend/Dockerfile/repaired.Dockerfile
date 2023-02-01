FROM node:8.5.0

RUN mkdir /opt/frontend

ADD package.json /opt/frontend
ADD package-lock.json /opt/frontend
RUN cd /opt/frontend && npm install && npm cache clean --force;

ADD src /opt/frontend/src
WORKDIR /opt/frontend
