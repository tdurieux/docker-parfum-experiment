FROM node:14.17.3-buster

WORKDIR /app

COPY . .

RUN npm install -g yarn && npm cache clean --force;
RUN yarn install && yarn cache clean;
RUN yarn build
RUN yarn cache clean

EXPOSE ${PORT}

CMD ["yarn", "preview"]