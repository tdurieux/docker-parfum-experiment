# from base image node
FROM node:12.11-slim

ENV workdirectory /usr/node

WORKDIR /aapp

COPY package.json .

RUN npm install && npm cache clean --force;

RUN echo "----> root"

COPY index.js .

ENTRYPOINT ["node"]
