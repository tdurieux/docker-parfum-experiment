FROM node:8.12-alpine

WORKDIR /usr/src/app

COPY package*.json lerna.json ./
COPY packages/base-server ./packages/base-server
COPY packages/crypto ./packages/crypto
COPY services/auth ./services/auth
RUN npm install --loglevel notice --unsafe-perm && npm cache clean --force;

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000
CMD ["npm", "--prefix", "services/auth", "start"]
