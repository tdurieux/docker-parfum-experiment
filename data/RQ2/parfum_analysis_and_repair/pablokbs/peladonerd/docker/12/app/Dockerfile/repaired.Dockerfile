FROM node:12.22.1-alpine3.11

WORKDIR /app
COPY . .
RUN yarn install --production && yarn cache clean;

CMD ["node", "/app/src/index.js"]
