FROM node:12

WORKDIR /wise-old-man/server

COPY package*.json ./
RUN npm install -s && npm cache clean --force;
RUN npm install pm2 -g && npm cache clean --force;

COPY . .
COPY wait-for-it.sh .

RUN npm run build

CMD ["npm", "start"]