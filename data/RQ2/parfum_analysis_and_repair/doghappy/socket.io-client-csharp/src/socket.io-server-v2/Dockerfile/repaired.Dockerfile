FROM node
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm i && npm cache clean --force;
COPY . .
EXPOSE 11002
CMD ["npm", "start"]