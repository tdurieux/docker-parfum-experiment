FROM node:14-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . ./
EXPOSE 4000
CMD ["yarn", "start"]
