FROM node:alpine

ENV NODE_ENV production

WORKDIR /app
ADD . .

EXPOSE 3000
RUN yarn install && yarn cache clean;
RUN yarn build
CMD ["yarn", "start"]