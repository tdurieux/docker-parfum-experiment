FROM node:12.16.0

WORKDIR /home/node/app/

COPY package.json yarn.* ./

RUN yarn && yarn cache clean;

COPY . .

CMD ["yarn", "start"]
