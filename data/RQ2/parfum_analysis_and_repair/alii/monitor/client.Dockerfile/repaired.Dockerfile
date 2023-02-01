FROM node:alpine
WORKDIR /app
ADD . .
RUN yarn && yarn cache clean;
RUN yarn client:build && yarn cache clean;
CMD ["yarn", "client:start"]
