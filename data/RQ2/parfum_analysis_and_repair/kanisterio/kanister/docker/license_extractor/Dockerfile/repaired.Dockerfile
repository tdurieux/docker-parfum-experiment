FROM node:14-alpine
RUN npm i -g license-extractor && npm cache clean --force;
RUN mkdir /repo

WORKDIR /repo

ENTRYPOINT ["licext"]
