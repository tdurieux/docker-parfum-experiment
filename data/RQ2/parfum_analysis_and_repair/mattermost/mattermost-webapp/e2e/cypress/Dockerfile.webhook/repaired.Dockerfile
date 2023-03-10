FROM node:14-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

WORKDIR /usr/src
RUN npm install axios express client-oauth2@larkox/js-client-oauth2#e24e2eb5dfcbbbb3a59d095e831dbe0012b0ac49 && npm cache clean --force;
COPY ./tests/plugins/post_message_as.js /usr/src/tests/plugins/post_message_as.js
COPY ./utils/webhook_utils.js /usr/src/utils/webhook_utils.js
COPY ./webhook_serve.js /usr/src

EXPOSE 3000
CMD [ "node", "webhook_serve.js" ]
