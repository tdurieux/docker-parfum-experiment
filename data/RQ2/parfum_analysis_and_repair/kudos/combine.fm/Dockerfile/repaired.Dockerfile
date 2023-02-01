FROM node:14.2.0

WORKDIR /app

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn && yarn cache clean;

COPY . .

RUN yarn run build && yarn cache clean;

ENV PORT 3000
EXPOSE 3000

CMD ["yarn", "start"]
