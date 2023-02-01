FROM node:14.19

WORKDIR /app

ENV NUXT_HOST 0.0.0.0

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 3000

CMD ["yarn", "run", "dev"]
