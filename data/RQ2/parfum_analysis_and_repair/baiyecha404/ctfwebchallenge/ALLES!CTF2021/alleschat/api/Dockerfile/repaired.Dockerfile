FROM node:alpine

COPY print.html package.json server.js /app/
WORKDIR /app
RUN npm install && npm cache clean --force;

RUN chown -R node:node /app
USER node

CMD ["node", "server.js"]
