FROM node:16

RUN apt-get update -y && apt-get install --no-install-recommends build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ENV NODE_ENV production

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD [ "node", "index.js" ]
