FROM node:latest
RUN mkdir /runner
WORKDIR /runner
COPY tests/package.json .
RUN npm install -g && npm cache clean --force;
