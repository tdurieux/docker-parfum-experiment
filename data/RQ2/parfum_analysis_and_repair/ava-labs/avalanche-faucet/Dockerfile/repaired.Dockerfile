FROM node:18.2.0

WORKDIR /avalanche-faucet

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build

EXPOSE 8000

CMD ["npm", "start"]
