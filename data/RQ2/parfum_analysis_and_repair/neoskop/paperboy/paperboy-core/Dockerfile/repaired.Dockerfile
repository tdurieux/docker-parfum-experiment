FROM node:18.4.0-buster-slim
USER node
WORKDIR /home/node/
COPY --chown=node package*.json ./
RUN npm i && npm cache clean --force;
COPY . ./
CMD ["npm", "start"]