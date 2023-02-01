FROM node:12-alpine

ENV NODE_ENV=production

WORKDIR /app

COPY package.json package-lock.json ./

RUN apk add --no-cache build-base git python3
RUN npm install --also=dev && npm cache clean --force;

COPY . ./

RUN npm run compile

CMD ["npm", "run", "bot-update-mainnet"]
