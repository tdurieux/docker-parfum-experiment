FROM node:12.16.0-alpine

WORKDIR /usr/src/app
COPY *.yaml ./
RUN npm -g config set user root
RUN npm -g install artillery && npm cache clean --force;

COPY . .

CMD [ "artillery", "run", "data-api-load.yaml" ]