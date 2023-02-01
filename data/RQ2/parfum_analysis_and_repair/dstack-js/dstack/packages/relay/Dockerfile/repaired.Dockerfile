FROM node:lts

COPY package.json .
RUN yarn install --no-cache --silent && yarn cache clean;

COPY . .

CMD ["node", "src/start.js"]
