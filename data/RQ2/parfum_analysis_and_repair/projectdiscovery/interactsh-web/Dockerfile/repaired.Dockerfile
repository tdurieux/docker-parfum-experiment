FROM node:16
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
COPY ./ ./
RUN yarn install && yarn cache clean;
CMD ["yarn", "start"]