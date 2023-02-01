FROM node:12 as build

WORKDIR /home/node

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

ENV PORT 80
EXPOSE 80

CMD ["npm", "start"]
