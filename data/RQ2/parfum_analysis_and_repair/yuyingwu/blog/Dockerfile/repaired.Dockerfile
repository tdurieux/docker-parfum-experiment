FROM node:12-alpine
WORKDIR /app
COPY . .
RUN yarn install --production && yarn cache clean;
RUN yarn build
CMD ["yarn", "start"]