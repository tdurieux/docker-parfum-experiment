FROM node:14-alpine

RUN apk add --no-cache git
RUN yarn global add gulp && yarn cache clean;

CMD ["node", "--version"]
