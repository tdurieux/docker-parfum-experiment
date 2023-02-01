FROM node:12

WORKDIR /wise-old-man/discord-bot

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./
RUN npm install -s && npm cache clean --force;
RUN npm install pm2 -g && npm cache clean --force;

COPY . .
COPY wait-for-it.sh .

RUN npm run build

CMD ["npm", "start"]
