FROM node:12.20.1-stretch as base
WORKDIR /code
ADD . .
RUN cp flatc_debian_stretch flatc
RUN npm install && npm cache clean --force;
RUN npm test
