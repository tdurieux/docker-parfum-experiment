FROM node:lts

WORKDIR /app

EXPOSE 3000 35729
COPY . /app
RUN yarn install && yarn build && yarn cache clean;

CMD ["yarn", "serve"]
