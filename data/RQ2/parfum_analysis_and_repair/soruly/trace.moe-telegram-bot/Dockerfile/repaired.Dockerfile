FROM node:lts-alpine
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
ENV NODE_ENV=production
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production && npm cache clean --force;
COPY server.js ./
CMD [ "node", "server.js" ]