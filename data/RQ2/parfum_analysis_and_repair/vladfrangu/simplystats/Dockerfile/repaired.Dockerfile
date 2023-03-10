FROM node:alpine

WORKDIR /opt/bot

RUN apk --no-cache add git

COPY . .

RUN npm i && npm run ts:compile && npm cache clean --force;

ENTRYPOINT ["node", "."]
