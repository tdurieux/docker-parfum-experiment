# from base image node
FROM node:12.11-slim

WORKDIR /aapp

COPY package.json .

RUN npm install && npm cache clean --force;

RUN echo "----> TEST"

COPY index.js .

ENTRYPOINT ["node"]
