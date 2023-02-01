FROM hub.agoralab.co/agora_public/node:14.9-alpine

WORKDIR /RDC-SERVER

COPY package.json ./

RUN yarn install --production && yarn cache clean;

COPY dist/* ./

EXPOSE 3031

CMD [ "node", "main.js" ]