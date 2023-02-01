FROM node:lts-buster
WORKDIR /mern-stack/client
COPY ./client/package*.json ./
RUN npm install && npm cache clean --force;
CMD ["npm", "run", "start"]