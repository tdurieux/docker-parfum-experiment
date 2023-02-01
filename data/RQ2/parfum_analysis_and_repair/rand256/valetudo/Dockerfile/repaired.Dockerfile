FROM node:10-alpine

WORKDIR /
COPY . .

RUN npm install --quiet && npm cache clean --force;

ENTRYPOINT [ "npm", "run-script", "build" ]