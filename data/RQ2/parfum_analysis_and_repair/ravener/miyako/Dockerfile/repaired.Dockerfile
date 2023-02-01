FROM node:14-alpine
WORKDIR /app
RUN apk update && apk add --no-cache git ca-certificates

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
CMD ["node", "index.js"]
