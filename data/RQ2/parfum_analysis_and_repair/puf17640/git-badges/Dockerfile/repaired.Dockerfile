FROM node:alpine

WORKDIR /opt/git-badges

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "run", "start"]
