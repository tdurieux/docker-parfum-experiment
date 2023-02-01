FROM node:lts-buster
WORKDIR /mern-stack/server
COPY ./server/package*.json ./
RUN npm install && npm cache clean --force;
COPY ./.env ../.env
CMD ["npm", "run", "start"]