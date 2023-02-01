FROM node:lts-jessie

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/telegram-forwarder/bot

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD ["node", "bot.js"]