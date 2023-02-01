FROM node:alpine
WORKDIR /erxes
COPY yarn.lock package.json ./
RUN yarn install && yarn cache clean;
CMD ["yarn", "start"]