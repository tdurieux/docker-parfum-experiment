FROM node:alpine

WORKDIR /home/autolabel

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .

ENTRYPOINT ["node", "/home/autolabel/dist/index.js"]
