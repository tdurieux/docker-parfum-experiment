FROM node:8

RUN mkdir -p /opt/binaris
WORKDIR /opt/binaris
COPY . ./
RUN npm i && npm cache clean --force;

VOLUME /src
WORKDIR /src

ENTRYPOINT ["node", "/opt/binaris/cli.js"]
