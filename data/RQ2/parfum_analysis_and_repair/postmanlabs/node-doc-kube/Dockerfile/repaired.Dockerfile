FROM node:alpine

WORKDIR /app

ENV NODE_ENV="production"

COPY package.json yarn.loc[k] package-lock.jso[n] /app/

RUN \

  yarn install --no-cache --production && \
  adduser -S nodejs && \
  chown -R nodejs /app && \
  chown -R nodejs /home/nodejs && yarn cache clean;

COPY . /app/

USER nodejs

CMD ["node", "src/services/server.js"]
