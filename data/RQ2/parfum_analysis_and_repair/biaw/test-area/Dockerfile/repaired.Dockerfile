FROM node:16-alpine
RUN apk add --no-cache dumb-init g++ gcc make python3

WORKDIR /app

COPY package*.json ./
RUN npm i && npm cache clean --force;

COPY . ./
RUN npm run build

CMD ["dumb-init", "npm", "start"]