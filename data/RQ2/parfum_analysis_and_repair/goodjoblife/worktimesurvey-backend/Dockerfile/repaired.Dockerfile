FROM node:14

COPY . /app

WORKDIR /app

ENV NODE_ENV=production

RUN yarn install && yarn cache clean;

EXPOSE 3000

CMD ["npm", "run", "start"]
