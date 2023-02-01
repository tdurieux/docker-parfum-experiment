FROM node:lts-bullseye

ENV HOME=/home/node
WORKDIR $HOME

COPY package*.json $HOME
RUN npm install && npm cache clean --force;
COPY . $HOME

EXPOSE 3000
CMD ["npm", "start"]