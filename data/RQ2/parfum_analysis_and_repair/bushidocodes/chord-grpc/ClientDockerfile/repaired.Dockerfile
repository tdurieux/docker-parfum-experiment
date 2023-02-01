FROM node:13-alpine
USER node
WORKDIR /home/node
COPY --chown=node:node package*.json ./
RUN npm install && npm cache clean --force;
COPY --chown=node:node . .
EXPOSE 1337
CMD [ "node", "./client/client.js"]
