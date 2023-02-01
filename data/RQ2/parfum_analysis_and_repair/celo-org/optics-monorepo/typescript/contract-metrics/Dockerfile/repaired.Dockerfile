FROM node:16.9.1
ENV NODE_ENV=production

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm install --production && npm cache clean --force;

COPY src ./src

CMD [ "npm", "run", "monitor" ]