FROM node:16.5.0-alpine

WORKDIR /app
COPY . .
RUN yarn && yarn cache clean;

ENTRYPOINT ["node", "lib/index.js"]
