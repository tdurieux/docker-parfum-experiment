FROM node:7-alpine

ADD ./ /app

RUN cd /app && npm i && npm run build && npm i --production && sh ./clear.sh && npm cache clean --force;

CMD ["node", "/app/app"]
