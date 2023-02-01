FROM node:latest
WORKDIR /client
COPY package*.json /client/
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY . /client
CMD [ "npm" , "run" , "start"]