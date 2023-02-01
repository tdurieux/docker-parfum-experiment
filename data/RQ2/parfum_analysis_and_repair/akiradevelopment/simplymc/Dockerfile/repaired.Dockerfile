FROM node:17.6.0

WORKDIR /home/stuff/SimplyMC

COPY package*.json ./

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 420

CMD [ "node", "." ]