FROM node:14

COPY package.json ./
COPY yarn.lock ./
COPY aws-emulator.js ./

RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD ["node", "./aws-emulator.js"]
