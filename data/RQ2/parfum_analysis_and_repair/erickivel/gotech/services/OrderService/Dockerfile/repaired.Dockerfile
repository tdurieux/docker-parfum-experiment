FROM node

WORKDIR /usr/app

COPY package.json ./

RUN yarn && yarn cache clean;

COPY . .

EXPOSE 3333

CMD ["yarn", "dev"]
