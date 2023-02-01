FROM node:12

WORKDIR /app

COPY . .

RUN yarn install && yarn cache clean;

EXPOSE 3000

CMD ["npm","run", "cap"]
