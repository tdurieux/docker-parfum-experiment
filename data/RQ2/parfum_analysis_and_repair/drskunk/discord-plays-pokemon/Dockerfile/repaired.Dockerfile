FROM node:lts
WORKDIR /usr/discordplayspokemon
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
CMD [ "npm", "start" ]
