FROM node:16-slim

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .

ENTRYPOINT ["yarn"]
CMD ["start"]
