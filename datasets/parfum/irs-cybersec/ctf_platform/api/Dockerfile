FROM node:lts-bullseye
WORKDIR /usr/src/app
COPY package*.json ./

RUN npm ci --only=production
COPY . .
RUN npm install pm2 -g

EXPOSE 20001
USER node
RUN NODE_ENV=production
CMD ["pm2-runtime", "api.js"]
