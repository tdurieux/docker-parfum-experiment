FROM node:alpine
WORKDIR /app
ADD . .
RUN yarn && yarn cache clean;
RUN yarn server:build && yarn cache clean;
CMD ["yarn", "server:start"]
