FROM node:14.18.0
WORKDIR /app
COPY package.json ./
RUN yarn && yarn cache clean;
COPY . .
CMD ["yarn", "start"]